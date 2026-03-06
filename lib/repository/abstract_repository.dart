import 'package:looply/db/database_con.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class AbstractRepository {
  Database? dbconn;

  Future<void> init() async {
    dbconn = await DatabaseCon.instance;
  }
}