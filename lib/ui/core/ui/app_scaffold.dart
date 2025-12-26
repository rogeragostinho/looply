import 'package:flutter/material.dart';
import 'package:looply/ui/app/app_bottom_app_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: AppBottomAppBar()
    );
  }
}