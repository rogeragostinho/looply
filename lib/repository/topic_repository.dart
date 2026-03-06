import 'package:looply/model/topic.dart';
import 'package:looply/repository/abstract_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../core/constants/db_constants.dart';

class TopicRepository extends AbstractRepository {
  static TopicRepository? _repository;

  TopicRepository._internal();

  factory TopicRepository() {
    return _repository ??= TopicRepository._internal();
  }

  /// Inserir um novo Topic
  Future<int> insertTopic(Topic topic) async {
    final dbconn = await db;

    final map = topic.toMap();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await dbconn.insert(DBTables.topics, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Atualizar um Topic existente
  Future<int> updateTopic(Topic topic) async {
    final dbconn = await db;

    if (topic.id == null) throw Exception("Topic id is null, cannot update.");

    return await dbconn.update(
      DBTables.topics,
      topic.toMap(), 
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [topic.id],
    );
  }

  /// Deletar um Topic pelo id
  Future<int> delete(int id) async {
    final dbconn = await db;

    return await dbconn.delete(
      DBTables.topics,
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [id],
    );
  }

  /// Buscar um Topic pelo id
  Future<Topic?> getTopicById(int id) async {
    final dbconn = await db;

    final maps = await dbconn.query(
      DBTables.topics,
      where: '${TopicsColumns.colId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Topic.fromMap(maps.first);
    }
    return null;
  }

  /// Buscar todos os Topics
  Future<List<Topic>> getAllTopics() async {
    final dbconn = await db;

    final maps = await dbconn.query(DBTables.topics, orderBy: '${TopicsColumns.colStudiedOn} DESC');
    return maps.map((map) => Topic.fromMap(map)).toList();
  }

  /// Contar todos os Topics
  Future<int> count() async {
    final dbconn = await db;

    final x = await dbconn.rawQuery('SELECT COUNT(*) FROM ${DBTables.topics}');
    return Sqflite.firstIntValue(x) ?? 0;
  }
}
