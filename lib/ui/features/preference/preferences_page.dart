import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';

class PreferencesPage extends StatelessWidget {

  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: "Preferências"),
      body: Column(
        children: [
          Text("Preferences"),
          ElevatedButton(onPressed: () {
            context.push(AppRoutes.tags);
          }, child: Text("Tags")),
          ElevatedButton(onPressed: () {
            context.push(AppRoutes.revisionCycles);
          }, child: Text("Ciclos de revisão")),
        ],
      ),
    );
  }
}