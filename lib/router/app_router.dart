import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/app_scaffold.dart';
import 'package:looply/ui/features/preference/preferences_page.dart';
import 'package:looply/ui/features/calendar/calendar_page.dart';
import 'package:looply/ui/features/home/home_page.dart';
import 'package:looply/ui/features/tag/tags_page.dart';
import 'package:looply/ui/features/topic/add_note_page.dart';
import 'package:looply/ui/features/topic/add_topic_page.dart';
import 'package:looply/ui/features/topic/args/add_note_args.dart';
import 'package:looply/ui/features/topic/args/view_image%20args.dart';
import 'package:looply/ui/features/topic/topic_details_page.dart';
import 'package:looply/ui/features/topic/topics_page.dart';
import 'package:looply/ui/features/topic/view_image_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(title: "title"),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.topics,
              builder: (context, state) => const TopicsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.calendar,
              builder: (context, state) => const CalendarPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.preferences,
              builder: (context, state) => const PreferencesPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.topicAdd,
      builder: (context, state) => const AddTopicPage(),
    ),
    GoRoute(
      path: AppRoutes.topicDetail,
      builder: (context, state) {
        final topicId = state.extra as int;
        return TopicDetailsPage(topicId: topicId);
      }
    ),
    GoRoute(
      path: AppRoutes.topicAddNote,
      builder: (context, state) {
        final args = state.extra as AddNoteArgs;
        return AddNotePage(args: args);
      }
    ),
    GoRoute(
      path: AppRoutes.topicViewImage,
      builder: (context, state) {
        final args = state.extra as ViewImageArgs;
        return ViewImagePage(args: args);
      }
    ),
    GoRoute(
      path: AppRoutes.tags,
      builder: (context, state) => const TagsPage(),
    ),
  ],
);