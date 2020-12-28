import 'package:sqflite/sqflite.dart';
import 'database.dart';

final String customerTable = 'clientes';
final String idColuna = 'id';
final String nomeColuna = 'nome';
final String enderecoColuna = 'endereco';
final String bairroColuna = 'bairro';
final String cepColuna = 'cep';
final String cidadeColuna = 'cidade';
final String estadoColuna = 'uf';
final String cpfColuna = 'cpf';


class CustomerHelper {

  static final CustomerHelper _instance = CustomerHelper.internal();

  factory CustomerHelper() => _instance;

  CustomerHelper.internal();

  DataBaseHelper dbHelper = DataBaseHelper();

  Future<Customer> saveCustomer (Customer customer) async{
    Database dbCustomer = await dbHelper.getDb;
    customer.id = await dbCustomer.insert(customerTable, customer.toMap());
    return customer;
  }

  Future<int> deleteCustomer(int id) async {
    Database dbCustomer = await dbHelper.getDb;
    return dbCustomer.delete(customerTable, where: '$idColuna = ?', whereArgs: [id]);
  }

  Future<int> updateCustomer(Customer customer) async {
    Database dbCustomer = await dbHelper.getDb;
    return dbCustomer.update(customerTable, customer.toMap(), where: '$idColuna = ?', whereArgs: [customer.id]);
  }
  
  Future<List> getAllCustomers() async{
    Database dbCustomer = await dbHelper.getDb;
    List listMap = await dbCustomer.rawQuery('SELECT * FROM $customerTable');
    List<Customer> listCustomer = List();
    for (Map m in listMap) {
      listCustomer.add(Customer.fromMap(m));
    }
    return listCustomer;
  }

  Future<int> getCountCustomers () async {
    Database dbCustomer = await dbHelper.getDb;
    return Sqflite.firstIntValue(await dbCustomer.rawQuery('SELECT COUNT(*) FROM $customerTable'));
  }

}

class Customer {
  int id;
  String nome;
  String endereco;
  String bairro;
  String cep;
  String cidade;
  String estado;
  String cpf;

  Customer();

  Customer.fromMap(Map map){
    id = map[idColuna];
    nome = map[nomeColuna];
    endereco = map[enderecoColuna];
    bairro = map[bairroColuna];
    cep = map[cepColuna];
    cidade = map[cidadeColuna];
    estado = map[estadoColuna];
    cpf = map[cpfColuna];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nomeColuna : nome,
      enderecoColuna : endereco,
      bairroColuna : bairro,
      cepColuna : cep,
      cidadeColuna : cidade,
      estadoColuna : estado,
      cpfColuna : cpf
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

}