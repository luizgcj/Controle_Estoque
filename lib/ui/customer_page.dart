import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:controle_estoque/helpers/customer_helper.dart';

enum OrderOptions { excluir }

class CustomerPage extends StatefulWidget {
  @override
  Customer customer;

  CustomerHelper helper = CustomerHelper();

  CustomerPage({this.customer});

  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  final _nomeFocus = FocusNode();
  final _enderecoFocus = FocusNode();
  final _bairroFocus = FocusNode();
  final _cepFocus = FocusNode();
  final _cidadeFocus = FocusNode();
  final _estadoFocus = FocusNode();
  final _cpfFocus = FocusNode();

  Customer _editedCustomer;
  bool _CustomerEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.customer == null) {
      _editedCustomer = Customer();
    } else {
      _editedCustomer = Customer.fromMap(widget.customer.toMap());
      _nomeController.text = _editedCustomer.nome;
      _enderecoController.text = _editedCustomer.endereco;
      _bairroController.text = _editedCustomer.bairro;
      _cepController.text = _editedCustomer.cep;
      _cidadeController.text = _editedCustomer.cidade;
      _estadoController.text = _editedCustomer.estado;
      _cpfController.text = _editedCustomer.cpf;
    }
  }

  bool _ValidarCampos() {
    if (_editedCustomer.nome == null || _editedCustomer.nome.isEmpty) {
      FocusScope.of(context).requestFocus(_nomeFocus);
      return false;
    } else
      return true;
  }

  Future _excluirCliente(int id) async {
    await widget.helper.deleteCustomer(id);
    _editedCustomer = null;
    Navigator.pop(context, _editedCustomer);
  }

  Future<bool> _confirmaExclusao() {
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
                  return Future.value(false);
                },
                child: Text("Desistir"),
              ),
              FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    _excluirCliente(_editedCustomer.id);
                  }),
            ],
          );
        });
  }

  void _execOptions(OrderOptions result) async {
    switch (result) {
      case OrderOptions.excluir:
        await _confirmaExclusao();
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                child: Text('Excluir Cliente'),
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
            Navigator.pop(context, _editedCustomer);
          }
        },
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.nome = text;
                  });
                },
                controller: _nomeController,
                focusNode: _nomeFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nome do Cliente',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.endereco = text;
                  });
                },
                controller: _enderecoController,
                focusNode: _enderecoFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.bairro = text;
                  });
                },
                controller: _bairroController,
                focusNode: _bairroFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Bairro',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.cep = text;
                  });
                },
                controller: _cepController,
                focusNode: _cepFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Cep',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.cidade = text;
                  });
                },
                controller: _cidadeController,
                focusNode: _cidadeFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.estado = text;
                  });
                },
                controller: _estadoController,
                focusNode: _estadoFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'UF',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _CustomerEdited = true;
                  setState(() {
                    _editedCustomer.cpf = text;
                  });
                },
                controller: _cpfController,
                focusNode: _cpfFocus,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 15.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
