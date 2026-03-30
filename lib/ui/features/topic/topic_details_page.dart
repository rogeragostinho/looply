import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/features/topic/args/add_note_args.dart';
import 'package:looply/ui/features/topic/args/view_image%20args.dart';
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
    final topicVM = context
        .watch<TopicViewModel>(); // assiste às mudanças notificadas

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
                ElevatedButton.icon(
                  onPressed: () {
                    //showDialog(context: context, builder: (context) => TagDialog());
                    showDialog(
                      context: context,
                      builder: (context) =>
                          TopicNameDialog(topic: widget.topic),
                    );
                  },
                  label: Icon(Icons.edit),
                ),
              ],
            ),

            Text(
              "Tags:" 
                  "${widget.topic.tags.map((tag) {
                    return tag.name;
                  })}",
            ),

            SizedBox(height: 20),

            Text("Revision Timeline"),
            ...widget.topic.revisions!.map((revision) {
              return Text("${revision.date} - ${revision.status}");
            }),
            Card(
              child: widget.topic.note == null
                  ? Row(
                      children: [
                        Text("Adicionar Nota"),
                        ElevatedButton(
                          onPressed: () {
                            context.push(
                              AppRoutes.topicAddNote,
                              extra: AddNoteArgs(
                                topicId: widget.topic.id!,
                                editMode: false,
                              ),
                            );
                          },
                          child: Text("Adicionar"),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.push(
                              AppRoutes.topicAddNote,
                              extra: AddNoteArgs(
                                topicId: widget.topic.id!,
                                editMode: true,
                              ),
                            );
                          },
                          child: Text("Editar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.topic.note = null;
                            topicVM.update(widget.topic);
                          },
                          child: Text("Eliminar"),
                        ),
                        Text("Titulo: ${widget.topic.note!.title}"),
                        Text("Conteúdo: ${widget.topic.note!.content}"),
                      ],
                    ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Adicionar Imagens"),
                      ElevatedButton(
                        onPressed: () {
                          topicVM.addImage(widget.topic);
                        },
                        child: Text("Adicionar"),
                      ),
                    ],
                  ),
                  if (widget.topic.imagesUrl != null &&
                      widget.topic.imagesUrl!.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.topic.imagesUrl!.length,
                        itemBuilder: (context, index) {
                          final imgPath = widget.topic.imagesUrl![index];
                          return GestureDetector(
                            onTap: () {
                              context.push(AppRoutes.topicViewImage, extra: ViewImageArgs(topicId: widget.topic.id!, imageIndex: index));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(File(imgPath)),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
