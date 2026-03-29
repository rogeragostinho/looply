import 'package:flutter/material.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';

import 'package:go_router/go_router.dart';
import 'package:looply/router/app_routes.dart';
import 'package:provider/provider.dart';

class TopicRevisionCard extends StatelessWidget {
  final TopicRevision topicRevision;

  const TopicRevisionCard({super.key, required this.topicRevision});

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();

    return Card(
      child: GestureDetector(
        onTap: () {
          context.push(AppRoutes.topicDetail, extra: topicRevision.topic);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topicRevision.topic.tags.isNotEmpty
                        ? topicRevision.topic.tags.first.name
                        : "",
                  ),
                  Text(
                    "Iniciado em: ${topicRevision.topic.studiedOn.day}/${topicRevision.topic.studiedOn.month}/${topicRevision.topic.studiedOn.year}",
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(topicRevision.topic.name),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Data de Revisão: ${topicRevision.revision.date.day}/${topicRevision.revision.date.month}",
                  ),
                  ElevatedButton(
                    onPressed: () {
                      topicVM.markRevisionDone(
                        topicRevision.topic,
                        topicRevision.revision,
                      );
                    },
                    child: Text("Feito"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
