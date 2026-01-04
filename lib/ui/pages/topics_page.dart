import 'package:flutter/material.dart';
import 'package:looply/ui/core/ui/page_app_bar.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/service/topic_service.dart';

class TopicsPage extends StatelessWidget {

  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Topics"),
      body: ListView(
          children: [
            for (Topic topic in TopicService.instance.getAll())
              Card(
                child: Text(topic.name),
              )
          ],
        ),
    );
  }
}