import 'package:looply/db/database_con.dart';
import 'package:sqflite/sqflite.dart';

abstract class AbstractRepository<T> {

  Future<Database> get db async {
    return await DatabaseCon.instance;
  }

  Future<int> insert(T item);
  Future<int> update(T item);
  Future<int> delete(int id);
  Future<T?> getById(int id);
  Future<List<T>> getAll();
}