import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:controle_estoque/helpers/product_helper.dart';
import 'product_page.dart';

enum OrderOptions{orderId, orderNome}

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final ProductHelper helper = ProductHelper();

  List<Product> products = List();

  @override
  void initState() {
    super.initState();

    _getAllProducts();
  }

  void _getAllProducts() async {
    helper.getAllProducts().then((list) {
      setState(() {
        products = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions> (
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem(
                    child: Text('Ordenar Id'),
                    value: OrderOptions.orderId,
                ),
                const PopupMenuItem(
                    child: Text('Ordenar Descrição'),
                    value: OrderOptions.orderNome
                ),
              ],
            onSelected: _orderList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: _showProductPage),
      body: SingleChildScrollView(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _productCard(context, index);
          },
        ),
      ),
    );
  }

  void _orderList (OrderOptions result){
    switch (result){
      case OrderOptions.orderId:
        products.sort((a, b) {
          return a.id.compareTo(b.id);
        });
        break;
      case OrderOptions.orderNome:
        products.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
          });
        break;
    }
    setState(() {

    });
  }

  Widget _productCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Text(
                      products[index].id.toString() ?? '',
                      style: TextStyle(
                          fontSize: 15.0),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(' - '),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descrição: ' + products[index].nome ?? '',
                          style: TextStyle(
                              fontSize: 15.0),
                        ),
                        Row(
                          children: [
                          Text(
                            'Preço: R\$ ' + products[index].preco.toString() ?? '',
                            style: TextStyle(
                                fontSize: 15.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                          ),
                          Text(
                            'Estoque: ' + products[index].estoque.toString() ?? '',
                            style: TextStyle(
                                fontSize: 15.0),
                          ),
                        ]),
                      ],
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showProductPage(product: products[index]);
      },
      onLongPress: (){
        _deletarProduto(products[index].id);


      },
    );
  }

  Future<bool> _deletarProduto(int id) async{
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirma excluir Produto?'),
            content: Text('Se confirmar não será possível reverter essa ação!'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Desistir"),
              ),
              FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    helper.deleteProduct(id);
                    _getAllProducts();
                  }),
            ],
          );
        }
    );


    //
  }

  void _showProductPage({Product product}) async {
    final recProduct = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductPage(product: product)));
    if (recProduct != null) {
      if (product != null) {
        await helper.updateProduct(recProduct);
      } else {
        await helper.saveProduct(recProduct);
      }
    }
    _getAllProducts();
  }
}
