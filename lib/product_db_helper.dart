import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductDBHelper {
  static Database? _database;
  static final String tableName = 'favorite_products';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'products.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price TEXT,
            imageLink TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert(tableName, product, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProduct(int productId) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [productId]);
  }

  Future<List<Map<String, dynamic>>> getFavoriteProducts() async {
    final db = await database;
    return await db.query(tableName);
  }
}
