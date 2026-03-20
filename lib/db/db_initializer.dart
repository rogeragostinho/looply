// db_tables_creator.dart
import 'package:sqflite/sqflite.dart';
import 'database_con.dart';
import '../core/constants/db_constants.dart';

class DbInitializer {
  DbInitializer._(); // Construtor privado, não instancia

  /// Inicializa todas as tabelas
  static Future<void> init() async {
    final db = await DatabaseCon.instance;

    await _createTopicsTable(db);
    await _createTagsTable(db);
  }

  static Future<void> _createTopicsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.topics} (
        ${TopicsColumns.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TopicsColumns.colName} TEXT,
        ${TopicsColumns.colRevisionCycle} TEXT,
        ${TopicsColumns.colTags} TEXT,
        ${TopicsColumns.colNote} TEXT,
        ${TopicsColumns.colRevisions} TEXT,
        ${TopicsColumns.colImages} TEXT,
        ${TopicsColumns.colStudiedOn} TEXT
      )
    ''');
  }

  static Future<void> _createTagsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBTables.tags} (
        ${TagsColumns.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TagsColumns.colName} TEXT
      )
    ''');
  }
}