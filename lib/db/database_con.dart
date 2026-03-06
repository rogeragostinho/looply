import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseCon {

  static Database? _instance;

  DatabaseCon._();

  static Future<Database> get instance async {
    if (_instance != null) return _instance!;
    _instance = await initDB();
    return _instance!;
  }

  static Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db_looply.db');

    var db = await openDatabase(path, version: 1);

    return db;
  }
}