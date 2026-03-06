import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';

class TopicDetailsPage extends StatefulWidget {
  const TopicDetailsPage({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicDetailsPage> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topic"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.topic.name),
            Text("Topics:"),
            ...widget.topic.tags.map((tag) {
              return Text(tag.name);
            }),
            Text("Revision Timeline"),
            ...widget.topic.revisions!.map((revision) {
              return Text("${revision.date} - ${revision.status}");
            }),
            Card(
              child: Row(
                children: [
                  Text("Add Notes"),
                  ElevatedButton(onPressed: () {}, child: Text("Add"))
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Text("Add Imagens"),
                  ElevatedButton(onPressed: () {}, child: Text("Add"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}