import 'package:looply/db/database_con.dart';
import 'package:sqflite/sqflite.dart';

abstract class AbstractRepository {

  Future<Database> get db async {
    return await DatabaseCon.instance;
  }
}