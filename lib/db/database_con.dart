import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseCon {

  static Database? _db;

  DatabaseCon._();

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db_looply.db');

    var db = await openDatabase(path, version: 1);

    return db;
  }
}