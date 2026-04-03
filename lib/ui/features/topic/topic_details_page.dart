import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/features/topic/args/add_note_args.dart';
import 'package:looply/ui/features/topic/args/view_image%20args.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:looply/ui/features/topic/widgets/topic_name_dialog.dart';
import 'package:provider/provider.dart';

class TopicDetailsPage extends StatelessWidget {
  const TopicDetailsPage({super.key, required this.topicId});

  final int topicId;

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final topic = topicVM.getById(topicId);

    if (topic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tópico")),
        body: const Center(child: Text("Tópico não encontrado.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tópico")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(topic.name),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => TopicNameDialog(topic: topic),
                    );
                  },
                  label: const Icon(Icons.edit),
                ),
              ],
            ),

            Text(
              "Tags: ${topic.tags.map((tag) => tag.name).join(', ')}",
            ),

            const SizedBox(height: 20),

            const Text("Revision Timeline"),
            ...topic.revisions!.map((revision) {
              final day = revision.date.day;
              final month = revision.date.month;
              final year = revision.date.year;

              String status;
              Color color;

              switch (revision.status) {
                case RevisionStatus.done:
                  status = "feito";
                  color = Colors.green;
                  break;
                case RevisionStatus.pending:
                  status = "pendente";
                  color = Colors.orange;
                  break;
                default:
                  status = "por vir";
                  color = Colors.grey;
              }

              return Text(
                "$day/$month/$year - $status",
                style: TextStyle(color: color),
              );
            }),

            const SizedBox(height: 25),

            Card(
              child: topic.note == null
                  ? Row(
                      children: [
                        const Text("Adicionar Nota"),
                        ElevatedButton(
                          onPressed: () {
                            context.push(
                              AppRoutes.topicAddNote,
                              extra: AddNoteArgs(
                                topicId: topicId,
                                editMode: false,
                              ),
                            );
                          },
                          child: const Text("Adicionar"),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.push(
                                  AppRoutes.topicAddNote,
                                  extra: AddNoteArgs(
                                    topicId: topicId,
                                    editMode: true,
                                  ),
                                );
                              },
                              child: const Text("Editar"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                topic.note = null;
                                topicVM.update(topic);
                              },
                              child: const Text("Eliminar"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Titulo: ${topic.note!.title}"),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Conteúdo: ${topic.note!.content}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 25),

            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Adicionar Imagens"),
                      ElevatedButton(
                        onPressed: () => topicVM.addImage(topic),
                        child: const Text("Adicionar"),
                      ),
                    ],
                  ),
                  if (topic.imagesUrl != null && topic.imagesUrl!.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topic.imagesUrl!.length,
                        itemBuilder: (context, index) {
                          final imgPath = topic.imagesUrl![index];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                AppRoutes.topicViewImage,
                                extra: ViewImageArgs(
                                  topicId: topicId,
                                  imageIndex: index,
                                ),
                              );
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