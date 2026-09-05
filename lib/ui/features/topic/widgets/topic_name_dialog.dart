import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class TopicNameDialog extends StatefulWidget {
  final Topic topic;

  const TopicNameDialog({super.key, required this.topic});

  @override
  State<TopicNameDialog> createState() => _TopicNameDialogState();
}

class _TopicNameDialogState extends State<TopicNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.topic.name)
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.topic.name.length,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final name = _controller.text.trim();
    if (name != widget.topic.name) {
      widget.topic.name = name;
      context.read<TopicViewModel>().update(widget.topic);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Tópico"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: "Nome do Tópico"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "O nome não pode ficar vazio";
            }
            return null;
          },
          onFieldSubmitted: (_) => _save(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Cancelar"),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}