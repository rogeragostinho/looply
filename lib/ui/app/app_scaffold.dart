import 'package:flutter/material.dart';
import 'package:looply/ui/app/app_bottom_app_bar.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:looply/ui/pages/account_page.dart';
import 'package:looply/ui/pages/add_topic_page.dart';
import 'package:looply/ui/pages/calendar_page.dart';
import 'package:looply/ui/pages/home_page.dart';
import 'package:looply/ui/pages/topics_page.dart';
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
      body: <Widget>[
        HomePage(title: "fe"),
        TopicsPage(),
        CalendarPage(),
        AccountPage()
      ][appState.currentPageIndex],
      bottomNavigationBar: AppBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () => {
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => const AddTopicPage())
          )
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}