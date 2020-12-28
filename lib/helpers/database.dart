import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String DATABASE_NAME = 'estoque.db';
//Campos tabela Produto
final String productTable = 'produtos';
final String idProduto = 'id';
final String nomeProduto = 'descricaoProduto';
final String precoProduto = 'preco';
final String unidadeProduto = 'unidade';
final String estoqueProduto = 'estoque';

//Campos tabela Cliente
final String customerTable = 'clientes';
final String idCliente = 'id';
final String nomeCliente = 'nome';
final String enderecoCliente = 'endereco';
final String bairroCliente = 'bairro';
final String cepCliente = 'cep';
final String cidadeCliente = 'cidade';
final String estadoCliente = 'uf';
final String cpfCliente = 'cpf';

class DataBaseHelper {

  final String createTableProduct = 'CREATE TABLE $productTable ($idProduto INTEGER PRIMARY KEY, $nomeProduto VARCHAR(100), $precoProduto FLOAT, $unidadeProduto VARCHAR(6), $estoqueProduto FLOAT)';
  final String createTableCustomer = 'CREATE TABLE $customerTable ($idCliente INTEGER PRIMARY KEY, $nomeCliente VARCHAR(100), $enderecoCliente VARCHAR(100), $bairroCliente VARCHAR(50),' +
                                     '$cepCliente VARCHAR(8),' +
                                     '$cidadeCliente VARCHAR(80), $estadoCliente VARCHAR(2), $cpfCliente VARCHAR(11))';

  Database db;

  Future<Database> get getDb async {
    if (db != null) {
      return db;
    } else {
      await initDb();
      return db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, DATABASE_NAME);
    db = await openDatabase(
      path,
      onCreate: (db, version) async{
        await db.execute(createTableProduct);
        await db.execute(createTableCustomer);
      },
      version: 1,
    );
    return db;
  }

  /*Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath,'estoque.db');

    return await openDatabase(
        path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE $customerTable ($idCliente INTEGER PRIMARY KEY, $nomeCliente VARCHAR(100), $enderecoCliente VARCHAR(100), $bairroCliente VARCHAR(50), $cepCliente VARCHAR(8),' +
              '$cidadeCliente VARCHAR(80), $estadoCliente VARCHAR(2), $cpfCliente VARCHAR(11))'
      );
      await db.execute(
          'CREATE TABLE $productTable ($idProduto INTEGER PRIMARY KEY, $nomeProduto VARCHAR(100), $precoProduto FLOAT, $unidadeProduto VARCHAR(6), $estoqueProduto FLOAT)'
      );
    });
  }*/

  Future close() async {
    Database dbProduct = await getDb;
    dbProduct.close();
  }

}