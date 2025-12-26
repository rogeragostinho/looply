import 'package:flutter/material.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';

class TopicsPage extends StatelessWidget {

  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Topics"),
      body: Placeholder(),
    );
  }
}