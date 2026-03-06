import 'package:looply/model/tag.dart';
import 'package:looply/repository/abstract_repository.dart';
import 'package:sqflite/sqflite.dart';

class TagRepository extends AbstractRepository{
  static TagRepository? _repository;

  static const String tableName= 'tbl_tags';
  static const String colId= 'id';
  static const String colName = 'name';

  TagRepository._internal();

  factory TagRepository() {
    return _repository ??= TagRepository._internal();
  }

  Future<int> create(Tag tag) async {
    final dbconn = await db;

    final map = tag.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await dbconn.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Tag?> getTopicById(int id) async {
    final dbconn = await db;

    final maps = await dbconn.query(
      tableName,
      where: '$colId = ?',
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
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Tag>> getAll() async {
    final dbconn = await db;

    final maps = await dbconn.query(tableName, orderBy: '$colId DESC');
    return maps.map((map) => Tag.fromJson(map)).toList();
  }

  //delete all
}