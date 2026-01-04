import 'package:looply/db/database_con.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:sqflite/sqflite.dart';

class RevisionCycleRepository {
  static RevisionCycleRepository? _repository;
  Database? _db;

  static const String tableName= 'tbl_revision_cycle';
  static const String colId= 'id';
  static const String colName = 'name';
  static const String colCycle= 'cycle_json';

  RevisionCycleRepository._internal();

  factory RevisionCycleRepository() {
    return _repository ??= RevisionCycleRepository._internal();
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
        $colCycle TEXT
      )
    ''');
  }

  Future<int> create(RevisionCycle revision) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final map = revision.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await _db!.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(RevisionCycle revision) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    if (revision.id == null) throw Exception("Revision cycle id is null, cannot update.");

    return await _db!.update(
      tableName,
      revision.toJson(),
      where: '$colId = ?',
      whereArgs: [revision.id],
    );
  }

  /// Deletar um Topic pelo id
  Future<int> delete(int id) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    return await _db!.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<RevisionCycle?> getTopicById(int id) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final maps = await _db!.query(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return RevisionCycle.fromJson(maps.first);
    }
    return null;
  }

  /// Buscar todos os Topics
  Future<List<RevisionCycle>> getAllTopics() async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final maps = await _db!.query(tableName, orderBy: '$colId DESC');
    return maps.map((map) => RevisionCycle.fromJson(map)).toList();
  }

  /// Contar todos os Topics
  Future<int> count() async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final x = await _db!.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(x) ?? 0;
  }

}