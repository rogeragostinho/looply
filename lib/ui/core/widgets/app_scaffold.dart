import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/router/app_routes.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) { // Volta ao root da tab ao clicar nela novamente
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex,);
        },
        destinations: [
          NavigationDestination(selectedIcon: Icon(Icons.home, color: iconColor), icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(selectedIcon: Icon(Icons.topic, color: iconColor) ,icon: Icon(Icons.topic_outlined), label: "Tópicos"),
          //NavigationDestination(icon: Badge(child: Icon(Icons.calendar_month)), label: "Calendário"),
          NavigationDestination(selectedIcon: Icon(Icons.tune, color: iconColor) ,icon: Icon(Icons.tune_outlined) , label: "Preferências"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.topicAdd),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}