// my_app.dart
import 'package:flutter/material.dart';
import 'package:looply/core/constants/app_constants.dart';
import 'package:looply/core/theme/app_theme.dart';
import 'package:looply/router/app_router.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/service/image_service.dart';
import 'package:looply/service/topic_service.dart';
import 'package:looply/ui/features/tag/tag_view_model.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              TopicViewModel(TopicService(TopicRepository()), ImageService())
                ..loadTopics()
                ..updateStatus(),
        ), // .. cascade operator
        ChangeNotifierProvider(
          create: (_) => TagViewModel(TagRepository())..loadTags(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        //theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
