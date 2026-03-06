import 'package:looply/model/tag.dart';
import 'package:looply/repository/abstract_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../core/constants/db_constants.dart';

class TagRepository extends AbstractRepository{
  static TagRepository? _repository;

  TagRepository._internal();

  factory TagRepository() {
    return _repository ??= TagRepository._internal();
  }

  Future<int> create(Tag tag) async {
    final dbconn = await db;

    final map = tag.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await dbconn.insert(DBTables.tags, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Tag?> getTopicById(int id) async {
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

  Future<int> delete(int id) async {
    final dbconn = await db;

    return await dbconn.delete(
      DBTables.tags,
      where: '${TagsColumns.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Tag>> getAll() async {
    final dbconn = await db;

    final maps = await dbconn.query(DBTables.tags, orderBy: '${TagsColumns.colId} DESC');
    return maps.map((map) => Tag.fromJson(map)).toList();
  }

  //delete all
}