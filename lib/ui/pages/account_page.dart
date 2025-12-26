import 'package:flutter/material.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';

class AccountPage extends StatelessWidget {

  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "AccountPage"),
      body: Center(child: Text("AccountPage"),)
    );
  }
}