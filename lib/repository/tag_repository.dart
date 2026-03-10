import 'package:looply/model/tag.dart';
import 'package:looply/repository/abstract_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../core/constants/db_constants.dart';

class TagRepository extends AbstractRepository<Tag> { 

  // ============ METODOS ==============
  @override
  Future<int> insert(Tag tag) async {
    final dbconn = await db;

    final map = tag.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await dbconn.insert(DBTables.tags, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<Tag?> getById(int id) async {
    final dbconn = await db;

    final maps = await dbconn.query(
      DBTables.tags,
      where: '${TagsColumns.colId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Tag.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<int> delete(int id) async {
    final dbconn = await db;

    return await dbconn.delete(
      DBTables.tags,
      where: '${TagsColumns.colId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Tag>> getAll() async {
    final dbconn = await db;

    final maps = await dbconn.query(DBTables.tags, orderBy: '${TagsColumns.colId} DESC');
    return maps.map((map) => Tag.fromJson(map)).toList();
  }

  @override
  Future<int> update(Tag tag) async {
    final dbconn = await db;

    if (tag.id == null) throw Exception("Tag id is null, cannot update.");

    return await dbconn.update(
      DBTables.topics,
      tag.toJson(), 
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [tag.id],
    );
  }

}