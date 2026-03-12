import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/app_scaffold.dart';
import 'package:looply/ui/features/preference/preferences_page.dart';
import 'package:looply/ui/features/calendar/calendar_page.dart';
import 'package:looply/ui/features/home/home_page.dart';
import 'package:looply/ui/features/revision_cycle/revision_cycles_page.dart';
import 'package:looply/ui/features/tag/tags_page.dart';
import 'package:looply/ui/features/topic/add_topic_page.dart';
import 'package:looply/ui/features/topic/topic_details_page.dart';
import 'package:looply/ui/features/topic/topics_page.dart';

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
        final topic = state.extra as Topic;
        return TopicDetailsPage(topic: topic);
      }
    ),
    GoRoute(
      path: AppRoutes.tags,
      builder: (context, state) => const TagsPage(),
    ),
    GoRoute(
      path: AppRoutes.revisionCycles,
      builder: (context, state) => const RevisionCyclesPage(),
    ),
  ],
);