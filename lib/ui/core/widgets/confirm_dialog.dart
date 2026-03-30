// lib/ui/core/widgets/confirm_dialog.dart

import 'package:flutter/material.dart';

// ===========================================
// ========== EXEMPLOS DE CHAMADA ============
// ===========================================

// Exemplo 1 — eliminar nota
/*
ElevatedButton(
  onPressed: () async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Eliminar nota",
      message: "Tens a certeza que queres eliminar esta nota?",
      confirmLabel: "Eliminar",
      isDanger: true,
    );
    if (!confirmed) return;
    widget.topic.note = null;
    topicVM.update(widget.topic);
  },
  child: const Text("Eliminar"),
),

// Exemplo 2 — eliminar imagem
ElevatedButton(
  onPressed: () async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Eliminar imagem",
      message: "Esta ação não pode ser desfeita.",
      confirmLabel: "Eliminar",
      isDanger: true,
    );
    if (!confirmed) return;
    topicVM.removeImage(args.topic, args.topic.imagesUrl![args.imageIndex]);
    context.pop();
  },
  child: const Text("Eliminar"),
),

// Exemplo 3 — operação não destrutiva
ElevatedButton(
  onPressed: () async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Marcar como concluída",
      message: "Queres marcar esta revisão como concluída?",
    );
    if (!confirmed) return;
    topicVM.markRevisionDone(topic, revision);
  },
  child: const Text("Concluir"),
),
*/
// ===========================================

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDanger;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.message = "Tens a certeza que queres continuar?",
    this.confirmLabel = "Confirmar",
    this.cancelLabel = "Cancelar",
    this.isDanger = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    String message = "Tens a certeza que queres continuar?",
    String confirmLabel = "Confirmar",
    String cancelLabel = "Cancelar",
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDanger: isDanger,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDanger
              ? ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}