import 'package:flutter/material.dart';
import 'package:looply/db/db_initializer.dart';
import 'package:looply/my_app.dart';
import 'package:looply/service/notification_service.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  DbInitializer.init();

  await NotificationService().init();
  await NotificationService().requestPermission();

  runApp(const MyApp());
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Caminho do banco
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'db_looply.db');

  // Apaga o banco se existir
  await deleteDatabase(path);

  // Inicializa de novo
  await DbInitializer.init();

  runApp(const MyApp());
}*/