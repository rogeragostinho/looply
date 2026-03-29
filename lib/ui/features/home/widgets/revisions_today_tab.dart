import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:looply/ui/features/topic/widgets/topic_revision_card.dart';
import 'package:provider/provider.dart';

class RevisionsTodayTab extends StatefulWidget {
  const RevisionsTodayTab({super.key});

  @override
  State<RevisionsTodayTab> createState() => _RevisionsTodayTabState();
}

class _RevisionsTodayTabState extends State<RevisionsTodayTab> {
  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();

    List<TopicRevision>? todayTopicRevisions = topicVM.getTodayRevisions();

    if (topicVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todayTopicRevisions.isEmpty) {
      return Center(child: Text("Sem revisões para hoje"));
    }

    return ListView(
      children: todayTopicRevisions.map((topicRevision) {
        return TopicRevisionCard(topicRevision: topicRevision);
      }).toList(), //->aqui
    );
  }
}
