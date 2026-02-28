import 'package:looply/db/database_con.dart';
import 'package:looply/model/topic.dart';
import 'package:sqflite/sqflite.dart';

class TopicRepository {
  static TopicRepository? _repository;
  Database? _db;

  static const String tableName = "tbl_topics";
  static const String colId = 'id';
  static const String colName = "name";
  static const String colRevisionCycle = 'revision_cycle_json';
  static const String colTags = 'tags_json';
  static const String colNote = 'note_json';
  static const String colRevisions = 'revisions_json';
  static const String colImages = 'images_url_json';
  static const String colStudiedOn = 'studied_on';

  TopicRepository._internal();

  factory TopicRepository() {
    return _repository ??= TopicRepository._internal();
  }

  /// Inicializa o banco e cria a tabela
  Future<void> init() async {
    _db = await DatabaseCon.db;
    await _createTable(_db!);
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
        $colRevisionCycle TEXT,
        $colTags TEXT,
        $colNote TEXT,
        $colRevisions TEXT,
        $colImages TEXT,
        $colStudiedOn TEXT
      )
    ''');
  }

  /// Inserir um novo Topic
  Future<int> insertTopic(Topic topic) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final map = topic.toMap();
    map.remove('id'); // remover id para o SQLite gerar automaticamente
    return await _db!.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Atualizar um Topic existente
  Future<int> updateTopic(Topic topic) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    if (topic.id == null) throw Exception("Topic id is null, cannot update.");

    return await _db!.update(
      tableName,
      topic.toMap(),
      where: '$colId = ?',
      whereArgs: [topic.id],
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

  /// Buscar um Topic pelo id
  Future<Topic?> getTopicById(int id) async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final maps = await _db!.query(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Topic.fromMap(maps.first);
    }
    return null;
  }

  /// Buscar todos os Topics
  Future<List<Topic>> getAllTopics() async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final maps = await _db!.query(tableName, orderBy: '$colStudiedOn DESC');
    return maps.map((map) => Topic.fromMap(map)).toList();
  }

  /// Contar todos os Topics
  Future<int> count() async {
    if (_db == null) throw Exception("Database not initialized. Call init() first.");
    final x = await _db!.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(x) ?? 0;
  }
}
