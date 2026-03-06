import 'package:looply/db/database_con.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/repository/abstract_repository.dart';
import 'package:sqflite/sqflite.dart';

class RevisionCycleRepository extends AbstractRepository {
  static RevisionCycleRepository? _repository;

  static const String tableName= 'tbl_revision_cycle';
  static const String colId= 'id';
  static const String colName = 'name';
  static const String colCycle= 'cycle_json';

  RevisionCycleRepository._internal();

  factory RevisionCycleRepository() {
    return _repository ??= RevisionCycleRepository._internal();
  }

  Future<int> create(RevisionCycle revision) async {
    final dbconn = await db;

    final map = revision.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await dbconn.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(RevisionCycle revision) async {
    final dbconn = await db;

    if (revision.id == null) throw Exception("Revision cycle id is null, cannot update.");

    return await dbconn.update(
      tableName,
      revision.toJson(),
      where: '$colId = ?',
      whereArgs: [revision.id],
    );
  }

  Future<int> delete(int id) async {
    final dbconn = await db;

    return await dbconn.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<RevisionCycle?> getById(int id) async {
    final dbconn = await db;

    final maps = await dbconn.query(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return RevisionCycle.fromJson(maps.first);
    }
    return null;
  }

  Future<List<RevisionCycle>> getAll() async {
    final dbconn = await db;

    final maps = await dbconn.query(tableName, orderBy: '$colId DESC');
    return maps.map((map) => RevisionCycle.fromJson(map)).toList();
  }

  Future<int> count() async {
    final dbconn = await db;

    final x = await dbconn.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(x) ?? 0;
  }

}