import 'package:flutter/material.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:looply/ui/features/topic/widgets/topic_revision_card.dart';
import 'package:provider/provider.dart';

class RevisionsOverdueTab extends StatelessWidget {
  const RevisionsOverdueTab({super.key});

  @override
  Widget build(BuildContext context) {

    final topicVM = context.watch<TopicViewModel>();

    final pendingTopicRevision = topicVM.getPendingRevisions();

    return ListView(
      children: pendingTopicRevision.map((topicRevision) {
        return TopicRevisionCard(topicRevision: topicRevision);
      }).toList(), //->aqui
    );
  }
}