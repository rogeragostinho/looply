import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("1"),),
              Tab(child: Text("2"),),
              Tab(child: Text("3"),)
            ]
          ),
        ),
        body: const TabBarView(
          children: [
            Text("1"),
            Text("2"),
            Text("3"),
          ]
        )
      ),
    );
  }
}