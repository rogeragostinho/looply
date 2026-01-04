import 'package:flutter/material.dart';
import 'package:looply/ui/app/app_scaffold.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: AppScaffold()
      )
    );
  }
}





