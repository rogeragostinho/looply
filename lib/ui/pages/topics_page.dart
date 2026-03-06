import 'package:flutter/material.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/service/topic_service.dart';
import 'package:looply/ui/pages/topic_details_page.dart';
import 'package:provider/provider.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  @override
  void initState() {
    super.initState();
    // Use context.read<AppState>() aqui porque você não quer que o initState fique escutando mudanças, só quer chamar a função.
    Future.microtask(() { // Executa isso depois do codigo atual terminar, evitar chamar o notifyListener antes d emontar a arvore de widgets
      final appState = context.read<AppState>();
      appState.getTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Topic>? topics = appState.topics;

    if (appState.isLoadingTopics) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: PageAppBar(title: "Topics"),
      body: ListView(
              children: [
                for (Topic topic in topics)
                  Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute<void>(
                            builder: (context) => TopicDetailsPage(topic: topic),
                          )
                        );
                      },
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                appState.deleteTopic(topic.id!.toInt()),
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
                    ),
                  ),
              ],
            ),
    );
  }
}
