import 'package:flutter/material.dart';
import 'package:looply/ui/app/app_bottom_app_bar.dart';
import 'package:looply/ui/pages/home_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        body: HomePage(title: "Home"),
        bottomNavigationBar: AppBottomAppBar(),
      )
    );
  }
}





