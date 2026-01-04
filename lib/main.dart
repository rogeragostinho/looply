import 'package:flutter/material.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/ui/app/main_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final topic = TopicRepository();
  await topic.init();

  final revision = RevisionCycleRepository();
  await revision.init();

  print("fefe");

  runApp(const MainApp());
}