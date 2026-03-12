import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/ui/features/topic/widgets/topic_card.dart';

class TopicsListView extends StatelessWidget {
  final List<Topic> topics;

  const TopicsListView({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];

        return TopicCard(topic: topic);
      }
    );
  }
}