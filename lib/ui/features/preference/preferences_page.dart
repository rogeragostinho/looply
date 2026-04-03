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
      body: ListView(
        children: [
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.tag),
            title: Text("Tags"),
            trailing: Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.tags),
          ),
          Divider(
            thickness: 1, // espessura da linha
            height: 20, // espaço vertical total ocupado (linha incluída)
            indent: 16, // espaço à esquerda antes da linha começar
            endIndent: 16, // espaço à direita onde a linha termina
            color: const Color.fromARGB(68, 158, 158, 158), // cor da linha
          ),
          ListTile(
            leading: Icon(Icons.tag),
            title: Text("Tags"),
            trailing: Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.tags),
          ),
        ],
      ),
    );
  }
}