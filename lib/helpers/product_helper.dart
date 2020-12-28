import 'package:controle_estoque/helpers/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String productTable = 'produtos';

final String idColuna = 'id';
final String nomeColuna = 'descricaoProduto';
final String precoColuna = 'preco';
final String unidadeColuna = 'unidade';
final String estoqueColuna = 'estoque';

class ProductHelper {
  //somente poderá ter uma instancia no projeto
  static final ProductHelper _instance = ProductHelper.internal();

  factory ProductHelper() => _instance;

  ProductHelper.internal();

  DataBaseHelper dbHelper = DataBaseHelper();

  Future<Product> saveProduct (Product product) async {
    Database dbProduct = await dbHelper.getDb;
    product.id = await dbProduct.insert(productTable, product.toMap());
    return product;
  }

  Future<Product> getProduct(int id) async {
    Database dbProduct = await dbHelper.getDb;
    List<Map> maps = await dbProduct.query(productTable,
    columns: [idColuna, nomeColuna, precoColuna, unidadeColuna, estoqueColuna],
    where: '$idColuna = ?',
    whereArgs: [id]);
    if (maps.length > 0) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteProduct (int id) async {
    Database dbProduct = await dbHelper.getDb;
    return await dbProduct.delete(productTable, where: '$idColuna = ?', whereArgs: [id]);
  }

  Future<int> updateProduct (Product product) async{
    Database dbProduct = await dbHelper.getDb;
    return await dbProduct.update(productTable,
    product.toMap(),
    where: '$idColuna = ?',
    whereArgs: [product.id]);
  }

  Future<List> getAllProducts() async {
    Database dbProduct = await dbHelper.getDb;
    List listMaps = await dbProduct.rawQuery('SELECT * FROM $productTable');
    List<Product> listProduct = List();
    for (Map m in listMaps) {
      listProduct.add(Product.fromMap(m));
    }
    return listProduct;
  }

  Future<int> getCountProducts () async {
    Database dbProduct = await dbHelper.getDb;
    return Sqflite.firstIntValue(await dbProduct.rawQuery('SELECT COUNT(*) FROM $productTable'));
  }

  Future close() async {
    Database dbProduct = await dbHelper.getDb;
    dbProduct.close();
  }

}

class Product {

  int id;
  String nome;
  double preco;
  String unidade;
  double estoque;

  Product();

  Product.fromMap(Map map) {
    id = map[idColuna];
    nome = map[nomeColuna];
    preco = map[precoColuna];
    unidade = map[unidadeColuna];
    estoque = map[estoqueColuna];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      nomeColuna: nome,
      precoColuna: preco,
      unidadeColuna: unidade,
      estoqueColuna: estoque
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Produto(id: $id, descrição: $nome, preço: $preco, unidade: $unidade, estoque: $estoque)";
  }
}