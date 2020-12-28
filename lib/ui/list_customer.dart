import 'package:controle_estoque/ui/customer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:controle_estoque/helpers/customer_helper.dart';
import 'product_page.dart';

enum OrderOptions{orderId, orderNome}

class ListCustomer extends StatefulWidget {
  @override
  _ListCustomerState createState() => _ListCustomerState();
}

class _ListCustomerState extends State<ListCustomer> {

  final CustomerHelper helper = CustomerHelper();

  List<Customer> customers = List();

  @override
  void initState() {
    super.initState();

    _getAllCustomers();
  }

  void _getAllCustomers() async {
    helper.getAllCustomers().then((list) {
      setState(() {
        customers = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
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
          child: Icon(Icons.add),
          onPressed: _showCustomerPage),
      body: SingleChildScrollView(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: customers.length,
          itemBuilder: (context, index) {
            return _customerCard(context, index);
          },
        ),
      ),
    );
  }

  void _orderList (OrderOptions result){
    switch (result){
      case OrderOptions.orderId:
        customers.sort((a, b) {
          return a.id.compareTo(b.id);
        });
        break;
      case OrderOptions.orderNome:
        customers.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

  Widget _customerCard(BuildContext context, int index) {
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
                      customers[index].id.toString() ?? '',
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
                          'Descrição: ' + customers[index].nome ?? '',
                          style: TextStyle(
                              fontSize: 15.0),
                        ),
                        Row(
                            children: [
                              Text(
                                'CPF: R\$ ' + customers[index].cpf.toString() ?? '',
                                style: TextStyle(
                                    fontSize: 15.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
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
        _showCustomerPage(customer: customers[index]);
      },
      onLongPress: (){
        _deletarCliente(customers[index].id);


      },
    );
  }

  Future<bool> _deletarCliente(int id) async{
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirma excluir Cliente?'),
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
                    helper.deleteCustomer(id);
                    _getAllCustomers();
                  }),
            ],
          );
        }
    );
  }

  void _showCustomerPage({Customer customer}) async {
    final recCustomer = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CustomerPage(customer: customer)));
    if (recCustomer != null) {
      if (customer != null) {
        await helper.updateCustomer(recCustomer);
      } else {
        await helper.saveCustomer(recCustomer);
      }
    }
    _getAllCustomers();
  }
}
