import 'package:flutter/material.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/service/topic_service.dart';
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
    final appState = context.read<AppState>();
    appState.getTopics();
  }

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AppState>();
    List<Topic>? topics = appState.topics;

    return Scaffold(
      appBar: PageAppBar(title: "Topics"),
      body: topics == null
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              for (Topic topic in topics)
                Card(child: Text(
                  '''${topic.id} - 
                  ${topic.name}\n
                  ${topic.revisionCycle.toString()}\n
                  ${topic.tags.toList().toString()}\n
                  ${topic.studiedOn.toString()}\n
                ''')),
            ],
          ),
    );
  }
}