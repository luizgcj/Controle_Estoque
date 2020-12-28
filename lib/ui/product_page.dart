import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:controle_estoque/helpers/product_helper.dart';

enum OrderOptions { excluir }

class ProductPage extends StatefulWidget {
  @override
  Product product;

  ProductHelper helper = ProductHelper();

  ProductPage({this.product});

  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _unidadeController = TextEditingController();
  final TextEditingController _estoqueController = TextEditingController();

  final _nomeFocus = FocusNode();
  final _precoFocus = FocusNode();
  final _unidadeFocus = FocusNode();
  final _estoqueFocus = FocusNode();

  Product _editedProduct;
  bool _productEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.product == null) {
      _editedProduct = Product();
    } else {
      _editedProduct = Product.fromMap(widget.product.toMap());
      _nomeController.text = _editedProduct.nome;
      _precoController.text = _editedProduct.preco.toString();
      _unidadeController.text = _editedProduct.unidade;
      _estoqueController.text = _editedProduct.estoque.toString();
    }
  }

  bool _ValidarCampos() {
    if (_editedProduct.nome == null || _editedProduct.nome.isEmpty) {
      FocusScope.of(context).requestFocus(_nomeFocus);
      return false;
    } else if (_editedProduct.preco == null || _editedProduct.preco == 0.0) {
      FocusScope.of(context).requestFocus(_precoFocus);
      return false;
    } else if (_editedProduct.unidade == null ||
        _editedProduct.unidade.isEmpty) {
      FocusScope.of(context).requestFocus(_unidadeFocus);
      return false;
    } else if (_editedProduct.estoque == null ||
        _editedProduct.estoque == 0.0) {
      FocusScope.of(context).requestFocus(_estoqueFocus);
      return false;
    } else
      return true;
  }

  Future _excluirProduto(int id) async {
      await widget.helper.deleteProduct(id);
      _editedProduct = null;
      Navigator.pop(context, _editedProduct);
  }

  Future<bool> _confirmaExclusao() {
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
                  return Future.value(false);
                },
                child: Text("Desistir"),
              ),
              FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    _excluirProduto(_editedProduct.id);
                  }),
            ],
          );
        });
  }

  void _execOptions(OrderOptions result) async {
    switch (result) {
      case OrderOptions.excluir:
        await _confirmaExclusao();//_excluirProduto(_editedProduct.id);
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                child: Text('Excluir produto'),
                value: OrderOptions.excluir,
              )
            ],
            onSelected: _execOptions,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_ValidarCampos()) {
            Navigator.pop(context, _editedProduct);
          }
        },
        child: Icon(Icons.save),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (text) {
                _productEdited = true;
                setState(() {
                  _editedProduct.nome = text;
                });
              },
              controller: _nomeController,
              focusNode: _nomeFocus,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Descrição do Produto',
                labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (text) {
                _productEdited = true;
                setState(() {
                  _editedProduct.preco = double.parse(text);
                });
              },
              controller: _precoController,
              focusNode: _precoFocus,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Preço',
                labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (text) {
                _productEdited = true;
                setState(() {
                  _editedProduct.unidade = text;
                });
              },
              controller: _unidadeController,
              focusNode: _unidadeFocus,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Unidade',
                labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (text) {
                _productEdited = true;
                setState(() {
                  _editedProduct.estoque = double.parse(text);
                });
              },
              controller: _estoqueController,
              focusNode: _estoqueFocus,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Estoque',
                labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
