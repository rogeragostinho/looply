import 'package:flutter/material.dart';
import 'package:looply/db/db_initializer.dart';
import 'package:looply/ui/app/main_app.dart';

void main(){
  //WidgetsFlutterBinding.ensureInitialized();

  DbInitializer.init();

  runApp(const MainApp());
}