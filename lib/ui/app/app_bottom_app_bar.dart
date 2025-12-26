import 'package:flutter/material.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:provider/provider.dart';

class AppBottomAppBar extends StatefulWidget {
  const AppBottomAppBar({super.key});

  @override
  State<AppBottomAppBar> createState() => _AppBottomAppBarState();
}

class _AppBottomAppBarState extends State<AppBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return NavigationBar(
      onDestinationSelected: (int index) {
        appState.chancePageIndex(index);
      },
      indicatorColor: Colors.amber,
      selectedIndex: appState.currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined), 
          label: "Home"
        ),
        NavigationDestination(
          icon: Icon(Icons.topic), 
          label: "Topics"
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.calendar_month)), 
          label: "Calendary"
        ),
        NavigationDestination(
          icon:Badge(label: Text("2"), child: Icon(Icons.account_balance)),
          label: "Account"
        ),
      ],
    );
  }
}