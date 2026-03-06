import 'package:looply/model/topic.dart';
import 'package:looply/repository/abstract_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../core/constants/db_constants.dart';

class TopicRepository extends AbstractRepository<Topic> {

  TopicRepository._privateConstructor();

  // ============ SINGLETON ===============
  static final TopicRepository _instance = TopicRepository._privateConstructor();
  static TopicRepository get instance => _instance;
  // =====================================

  // ============ METODOS ==============
  @override
  Future<int> insert(Topic topic) async {
    final dbconn = await db;

    final map = topic.toJson();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await dbconn.insert(DBTables.topics, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<int> update(Topic topic) async {
    final dbconn = await db;

    if (topic.id == null) throw Exception("Topic id is null, cannot update.");

    return await dbconn.update(
      DBTables.topics,
      topic.toJson(), 
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [topic.id],
    );
  }

  @override
  Future<int> delete(int id) async {
    final dbconn = await db;

    return await dbconn.delete(
      DBTables.topics,
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Topic?> getById(int id) async {
    final dbconn = await db;

    final maps = await dbconn.query(
      DBTables.topics,
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Topic.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<List<Topic>> getAll() async {
    final dbconn = await db;

    final maps = await dbconn.query(DBTables.topics, orderBy: '${TopicsColumns.colStudiedOn} DESC');
    return maps.map((map) => Topic.fromJson(map)).toList();
  }
}
