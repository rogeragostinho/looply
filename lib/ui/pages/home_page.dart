import 'package:flutter/material.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Home"),
      body: Center(child: Text("CENTER"),),
    );
  }
}