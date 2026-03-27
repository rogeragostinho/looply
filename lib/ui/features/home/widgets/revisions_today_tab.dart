import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/model/revision.dart';
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
    // **** TODAY DATE *****
    final today = DateTime.now();
    //

    final topicVM = context.watch<TopicViewModel>();

    List<TopicRevision>? todayTopicRevisions = topicVM.getTodayRevisions();

    if (topicVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todayTopicRevisions.isEmpty) {
      return Center(child: Text("Sem revisões para hoje"));
    }

    print(todayTopicRevisions.first.topic.name);

    return ListView(
      children: todayTopicRevisions.map((topicRevision) {
        final day = today.day;
        final month = today.month;
        final year = today.year;

        Revision? revisionToday;

        if (topicVM.isSameDay(topicRevision.revision.date, today)) {
          revisionToday = topicRevision.revision;
        }

        Color color;

        switch (topicRevision.revision.status) {
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
                    Text("Iniciado em: $day/$month/$year"),
                  ],
                ),
                Text(topicRevision.topic.name),
                ElevatedButton(onPressed: () {
                  topicVM.markRevisionDone(topicRevision.topic, topicRevision.revision);
                }, child: Text("Feito")),
                Column(
                  children: topicRevision.topic.revisions!.map((revision) {
                    Color color;

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
