import 'package:flutter/material.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';

class CalendarPage extends StatelessWidget {

  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Calendar"),
      body: Center(child: Text("Calendar"),)
    );
  }
}