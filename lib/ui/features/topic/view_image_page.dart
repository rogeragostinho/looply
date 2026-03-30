import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/model/topic.dart';
import 'dart:io';

import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';

class ViewImageArgs {
  final Topic topic;
  final int imageIndex;

  const ViewImageArgs({required this.topic, required this.imageIndex});
}

class ViewImagePage extends StatelessWidget {

  final ViewImageArgs args;

  const ViewImagePage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();

    return Scaffold(
      appBar: AppTopBar(title: "Visualizar Imagem"),
      body: SafeArea(child: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {
              topicVM.removeImage(args.topic, args.topic.imagesUrl![args.imageIndex]);
              context.pop();
            }, child: Text("Eliminar")),
            Expanded(child: Image.file(File(args.topic.imagesUrl![args.imageIndex]))),
          ],
        ),
      )),
    );
  }
}