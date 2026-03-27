import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
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

        return Card(
          child: GestureDetector(
            onTap: () {
              context.push(AppRoutes.topicDetail, extra: topicRevision.topic);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topicRevision.topic.tags.length > 1
                          ? topicRevision.topic.tags.first.name
                          : "",
                    ),
                    Text("Iniciado em: ${topicRevision.topic.studiedOn.day}/${topicRevision.topic.studiedOn.month}/${topicRevision.topic.studiedOn.year}"),
                  ],
                ),
                Text(topicRevision.topic.name),
                ElevatedButton(
                  onPressed: () {
                    topicVM.markRevisionDone(
                      topicRevision.topic,
                      topicRevision.revision,
                    );
                  },
                  child: Text("Feito"),
                ),
                Column(
                  children: topicRevision.topic.revisions!.map((revision) {
                    Color color;

                    if (revision == topicRevision.revision) {
                      color = Colors.orange;
                    } else {
                      switch (revision.status) {
                        case RevisionStatus.done:
                          color = Colors.green;
                          break;
                        case RevisionStatus.pending:
                          color = Colors.orange;
                          break;
                        default:
                          color = Colors.grey;
                          break;
                      }
                    }

                    return Text(
                      revision.date.toString(),
                      style: TextStyle(color: color),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(), //->aqui
    );
  }
}
