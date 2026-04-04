import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class TopicNameDialog extends StatelessWidget {

  final Topic topic;

  const TopicNameDialog({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {

    final TextEditingController controller = TextEditingController(text: topic.name);

    return AlertDialog(
      title: Text("Editar Tópico"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: "Nome do Tópico"),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(), //Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text;
            if (name.isEmpty) return;

            final topicVM = context.read<TopicViewModel>();

            topic.name = name;

            topicVM.update(topic);

            //Navigator.of(context).pop();
            context.pop();
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}