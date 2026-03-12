import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';

class CalendarPage extends StatelessWidget {

  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: "Calendar"),
      body: Center(child: Text("Calendar"),)
    );
  }
}