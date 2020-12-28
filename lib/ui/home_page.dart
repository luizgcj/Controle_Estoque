import 'package:flutter/material.dart';
import 'list_customer.dart';
import 'list_product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Controle de Estoque',
          style: TextStyle(
              color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          Padding(padding: EdgeInsets.all(2.0)),
          Expanded(
              child: Container(
            color: Colors.blue[50],
            child: Image(
              image: AssetImage('imagens/Estoque5.jpg'),
              fit: BoxFit.fill,
            ),
          )),
          Padding(padding: EdgeInsets.all(1.0)),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.blue,
                  child: RaisedButton(
                    padding: EdgeInsets.all(5.0),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListProduct()));
                    },
                    child: Text(
                      "Produtos",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.blue,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListCustomer()));
                    },
                    child: Text(
                      "Clientes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.blue,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {},
                    child: Text(
                      "Vendas",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(3.0)),
        ]),
      ),
    );
  }
}
