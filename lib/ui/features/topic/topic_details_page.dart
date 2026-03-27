import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:looply/ui/features/topic/widgets/topic_name_dialog.dart';
import 'package:provider/provider.dart';

class TopicDetailsPage extends StatefulWidget {
  const TopicDetailsPage({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicDetailsPage> createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  @override
  Widget build(BuildContext context) {
    context.watch<TopicViewModel>(); // assiste às mudanças notificadas

    return Scaffold(
      appBar: AppBar(title: Text("Topic")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.topic.name),
                ElevatedButton.icon(onPressed: () {
                  //showDialog(context: context, builder: (context) => TagDialog());
                  showDialog(context: context, builder: (context) => TopicNameDialog(topic: widget.topic));
                }, label: Icon(Icons.edit))
              ],
            ),
            
            Text(
              "Tags:" +
                  "${widget.topic.tags.map((tag) {
                    return tag.name;
                  })}",
            ),

            SizedBox(height: 20,),

            Text("Revision Timeline"),
            ...widget.topic.revisions!.map((revision) {
              return Text("${revision.date} - ${revision.status}");
            }),
            Card(
              child: Row(
                children: [
                  Text("Add Notes"),
                  ElevatedButton(onPressed: () {}, child: Text("Add")),
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Text("Add Imagens"),
                  ElevatedButton(onPressed: () {}, child: Text("Add")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
