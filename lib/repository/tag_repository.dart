import 'package:looply/db/database_con.dart';
import 'package:looply/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class TagRepository {
  static TagRepository? _repository;
  Database? _db;

  static const String tableName= 'tbl_tags';
  static const String colId= 'id';
  static const String colName = 'name';

  TagRepository._internal();

  factory TagRepository() {
    return _repository ??= TagRepository._internal();
  }

  Future<void> init() async {
    _db = await DatabaseCon.db;
    await _createTable(_db!);
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
      )
    ''');
  }

  Future<int> create(Tag tag) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final map = tag.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await _db!.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(int id) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    return await _db!.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Tag>> getAll() async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final maps = await _db!.query(tableName, orderBy: '$colId DESC');
    return maps.map((map) => Tag.fromJson(map)).toList();
  }
}