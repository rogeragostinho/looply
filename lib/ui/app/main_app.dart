import 'package:flutter/material.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/ui/app/app_scaffold.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:looply/view_model/revision_cycle_view_model.dart';
import 'package:looply/view_model/tag_view_model.dart';
import 'package:looply/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => TopicViewModel(TopicRepository())),
        ChangeNotifierProvider(create: (_) => RevisionCycleViewModel(RevisionCycleRepository())),
        ChangeNotifierProvider(create: (_) => TagViewModel(TagRepository()))
      ],
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





