import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/core/widgets/confirm_dialog.dart';
import 'package:looply/ui/features/topic/args/view_image%20args.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
 
class ViewImagePage extends StatelessWidget {
  final ViewImageArgs args;
 
  const ViewImagePage({super.key, required this.args});
 
  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final topic = topicVM.getById(args.topicId);
 
    if (topic == null) {
      return Scaffold(
        appBar: AppTopBar(title: "Imagem"),
        body: const Center(child: Text("Tópico não encontrado.")),
      );
    }
 
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Imagem",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: "Eliminar imagem",
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: "Eliminar imagem",
                message: "Esta ação não pode ser desfeita.",
                confirmLabel: "Eliminar",
                isDanger: true,
              );
              if (!confirmed) return;
              topicVM.removeImage(topic, topic.imagesUrl![args.imageIndex]);
              // ignore: use_build_context_synchronously
              context.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(
              File(topic.imagesUrl![args.imageIndex]),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}