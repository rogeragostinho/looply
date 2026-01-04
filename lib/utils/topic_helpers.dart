import 'package:path/path.dart';
import 'package:looply/model/topic.dart';
import 'package:sqflite/sqflite.dart';

class TopicHelpers {

  static TopicHelpers? _databaseHelper;
  static Database? _database;

  //Defininfo a estrutura da Tabela
  String tableName = "tbl_topics";
  String colId = 'id';
  String colName = "name";
  String colRevisionCycle = 'revision_cycle_json';
  String colTags = 'tags_json';
  String colNote = 'note_json';
  String colRevisions = 'revisions_json';

  //Criar conectar ao bd

  TopicHelpers._createInstance();

  factory TopicHelpers() {
    _databaseHelper ??= TopicHelpers._createInstance();

      return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await inicializaBanco();
    
    return _database!;
  }

  //cria a tabela no banco
  void _createBase(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$colName TEXT, '
      '$colRevisionCycle TEXT, '
      '$colTags TEXT, '
      '$colNote TEXT, '
      '$colRevisions TEXT '
    ')');
  }


  Future<Database> inicializaBanco() async {
    //pega o caminho dos Android ou IOS para salvar o bd
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db_looply.db');

    var baseDados = await openDatabase(path, version: 1,
      onCreate: _createBase
    );

    return baseDados;
  }

  //CRUD
  Future<int> insertTopic(Topic topic) async {
    
    // 1 - selecionar bd
    Database db = await database;

    int result = await db.insert(tableName, topic.toMap()); 

    return result;

  }


}