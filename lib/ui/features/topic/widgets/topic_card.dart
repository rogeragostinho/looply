import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    var topicVM = context.watch<TopicViewModel>();

    return Card(
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.topicDetail, extra: topic),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                topicVM.delete(topic.id!);
              }, 
              label: Icon(Icons.delete),
            ),
            Text('''
              ID: ${topic.id ?? 'No ID'}
              Name: ${topic.name}
              Revision Cycle: ${topic.revisionCycle.name} (${topic.revisionCycle.cycle})
              Tags: ${topic.tags.map((t) => t.name).join(', ')}
              Studied On: ${topic.studiedOn.toIso8601String()}
              Revisions: ${topic.revisions!.map((r) => ("${r.date} - ${r.status}")).join(', ')}
              Note: ${topic.note?.content ?? 'No note'}
              Images: ${topic.imagesUrl?.join(', ') ?? 'No images'}
            '''),
          ],
        ),
      )
    );
  }
}