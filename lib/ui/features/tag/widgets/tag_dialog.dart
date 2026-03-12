import 'package:flutter/material.dart';
import 'package:looply/model/tag.dart';
import 'package:looply/ui/features/tag/tag_view_model.dart';
import 'package:provider/provider.dart';

class TagDialog extends StatelessWidget {

  final String? initialValue;
  final int? tagId;

  const TagDialog({super.key, this.initialValue, this.tagId});

  @override
  Widget build(BuildContext context) {

    final TextEditingController controller = TextEditingController(text: initialValue ?? "");

    return AlertDialog(
      title: Text(tagId == null ? "Adicionar Tag" : "Editar Tag"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: "Nome da Tag"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isEmpty) return;

            final tagVM = context.read<TagViewModel>();

            if (tagId == null) {
              tagVM.insert(Tag(name));
            } else {
              tagVM.update(Tag(name, id: tagId));
            }

            Navigator.of(context).pop();
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}