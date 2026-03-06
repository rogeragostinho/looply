import 'package:flutter/material.dart';
import 'package:looply/db/db_initializer.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/ui/app/main_app.dart';

void main(){
  //WidgetsFlutterBinding.ensureInitialized();

  DbInitializer.init();

  runApp(const MainApp());
}