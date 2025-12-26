import 'package:flutter/material.dart';
import 'package:looply/ui/app/app_bottom_app_bar.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:looply/ui/pages/home_page.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: HomePage(title: "Home"),
      bottomNavigationBar: AppBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}