// my_app.dart
import 'package:flutter/material.dart';
import 'package:looply/core/constants/app_constants.dart';
import 'package:looply/router/app_router.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/ui/core/state/app_state.dart';
import 'package:looply/ui/features/revision_cycle/revision_cycle_view_model.dart';
import 'package:looply/ui/features/tag/tag_view_model.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => TopicViewModel(TopicRepository())),
        ChangeNotifierProvider(create: (_) => RevisionCycleViewModel(RevisionCycleRepository())),
        ChangeNotifierProvider(create: (_) => TagViewModel(TagRepository()))
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: ThemeData.light(),
        routerConfig: appRouter,
      )
    );
  }
}
