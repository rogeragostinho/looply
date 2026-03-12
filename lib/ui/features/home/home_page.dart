import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/ui/core/state/app_state.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/topic/topic_details_page.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/revision_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppTopBar(
          title: "Início",
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("HOJE")),
              Tab(child: Text("PERDIDO")),
              Tab(child: Text("POR VIR")),
            ],
          ),
        ) ,
        body: const TabBarView(
          children: [RevisionsTodayTab(), Text("2"), Text("3")],
        ),
      ),
    );
  }
}

class RevisionsTodayTab extends StatefulWidget {
  const RevisionsTodayTab({super.key});

  @override
  State<RevisionsTodayTab> createState() => _RevisionsTodayTabState();
}

class _RevisionsTodayTabState extends State<RevisionsTodayTab> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final appState = context.read<AppState>();
      appState.getTopics();
      appState.getTags();
      appState.getRevisionCycles();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Topic>? topics = appState.topics;

    if (appState.isLoadingTopics) {
      return const Center(child: CircularProgressIndicator());
    }

    if (topics.isEmpty) {
      return Center(child: Text("Sem revisões"));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final topicsWithRevisionToday = topics.where((topic) {
      return topic.revisions!.any((revision) {
        final revisionDate = DateTime(
          revision.date.year,
          revision.date.month,
          revision.date.day,
        );

        return revisionDate == today;
      });
    }).toList();

    return ListView(
      children: topicsWithRevisionToday.map((topic) {
        /*final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // Pega a revisão de hoje
        Revision revisionToday = topic.revisions.firstWhere((revision) {
          final revisionDate = DateTime(
            revision.date.year,
            revision.date.month,
            revision.date.day,
          );
          return revisionDate == today;
        }); */

        return Card(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => TopicDetailsPage(topic: topic),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${topic.id}"),
                    ElevatedButton.icon(
                      onPressed: () => appState.deleteTopic(topic.id!.toInt()),
                      label: Icon(Icons.delete),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(topic.tags.toString()),
                    Text("Iniciado em: ${topic.studiedOn}"),
                  ],
                ),
                Text(topic.name),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Pegar")),
                  ],
                ),
                Column(
                  children: topic.revisions!.map((revision) {
                    Color statusColor;

                    final today = DateTime(now.year, now.month, now.day);
                    final revisionDate = DateTime(
                      revision.date.year,
                      revision.date.month,
                      revision.date.day,
                    );

                    if (today == revisionDate) {
                      //status
                    }
                    switch (revision.status) {
                      case RevisionStatus.done:
                        statusColor = Colors.green;
                        break;
                      case RevisionStatus.pending:
                        statusColor = Colors.orange;
                        break;
                      default:
                        statusColor = Colors.black;
                    }

                    return Text(
                      "${revision.date}",
                      style: TextStyle(color: statusColor),
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
