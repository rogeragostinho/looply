import 'package:flutter/material.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:looply/ui/features/topic/widgets/topic_revision_card.dart';
import 'package:provider/provider.dart';

class RevisionsUpComingTab extends StatelessWidget {
  const RevisionsUpComingTab({super.key});
@override
  Widget build(BuildContext context) {

    final topicVM = context.watch<TopicViewModel>();

    final upComingTopicRevision = topicVM.getUpcomingRevisions();

    return ListView(
      children: upComingTopicRevision.map((topicRevision) {
        return TopicRevisionCard(topicRevision: topicRevision);
      }).toList(), //->aqui
    );
  }
}