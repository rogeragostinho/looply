import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/router/app_routes.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) { // Volta ao root da tab ao clicar nela novamente
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex,);
        },
        destinations: const [
          NavigationDestination(selectedIcon: Icon(Icons.home), icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.topic), label: "Tópicos"),
          NavigationDestination(icon: Badge(child: Icon(Icons.calendar_month)), label: "Calendário"),
          NavigationDestination(icon: Icon(Icons.tune) , label: "Preferências"),
          //NavigationDestination(icon:Badge(label: Text("2"), child: Icon(Icons.account_balance)), label: "Account"),
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