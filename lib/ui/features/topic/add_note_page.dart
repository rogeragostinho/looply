import 'package:flutter/material.dart';
import 'package:looply/model/note.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/ui/features/topic/topic_view_model.dart';
import 'package:provider/provider.dart';

class AddNoteArgs {
  final Topic topic;
  final bool editMode;

  AddNoteArgs({required this.topic, required this.editMode});
}

class AddNotePage extends StatefulWidget {
  final AddNoteArgs args;

  const AddNotePage({super.key, required this.args});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController contentController;

  late bool editMode;

  @override
  void initState() {
    super.initState();

    editMode = widget.args.editMode;

    titleController = TextEditingController();
    contentController = TextEditingController();

    if (editMode) {
      titleController.text = widget.args.topic.note?.title ?? "";
      contentController.text = widget.args.topic.note?.content ?? "";
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final topic = widget.args.topic;

    return Scaffold(
      appBar: AppTopBar(
        title: editMode ? "Editar Nota" : "Adicionar Nota",
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira Título";
                  }
                  return null;
                },
              ),
              Expanded(
                child: TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: "Conteúdo",
                  ),
                  maxLines: null,
                  expands: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira Conteúdo";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("CANCELAR"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (editMode) {
                    topic.note!.title = titleController.text;
                    topic.note!.content = contentController.text;
                  } else {
                    topic.note = Note(
                      titleController.text,
                      contentController.text,
                    );
                  }

                  topicVM.update(topic);
                  context.pop();
                }
              },
              child: const Text("SALVAR"),
            ),
          ],
        ),
      ),
    );
  }
}