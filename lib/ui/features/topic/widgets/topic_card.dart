import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/confirm_dialog.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;

  const TopicCard({super.key, required this.topic});

  Color _statusColor(RevisionStatus status) {
    switch (status) {
      case RevisionStatus.pending:
        return Colors.orange;
      case RevisionStatus.done:
        return Colors.green;
      case RevisionStatus.upComing:
        return Colors.grey;
    }
  }

  IconData _statusIcon(RevisionStatus status) {
    switch (status) {
      case RevisionStatus.done:
        return Icons.check_circle_rounded;
      case RevisionStatus.pending:
        return Icons.schedule_rounded;
      case RevisionStatus.upComing:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  String _statusLabel(RevisionStatus status) {
    switch (status) {
      case RevisionStatus.done:
        return "Feito";
      case RevisionStatus.pending:
        return "Pendente";
      case RevisionStatus.upComing:
        return "Por vir";
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicVM = context.read<TopicViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final day = topic.studiedOn.day.toString().padLeft(2, '0');
    final month = topic.studiedOn.month.toString().padLeft(2, '0');
    final year = topic.studiedOn.year;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.topicDetail, extra: topic.id!),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Nome + botão deletar ──────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      topic.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: "Eliminar Tópico",
                        isDanger: true,
                      );
                      if (!confirmed) return;
                      topicVM.delete(topic.id!);
                    },
                  ),
                ],
              ),

              // ── Data de estudo ───────────────────────────
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Estudado em $day/$month/$year",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),

              // ── Tags ─────────────────────────────────────
              if (topic.tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: topic.tags
                      .map(
                        (t) => Chip(
                          label: Text(t.name),
                          labelStyle: theme.textTheme.labelSmall,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],

              // ── Revisões ─────────────────────────────────
              if (topic.revisions != null && topic.revisions!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: topic.revisions!.map((r) {
                    final rDay = r.date.day.toString().padLeft(2, '0');
                    final rMonth = r.date.month.toString().padLeft(2, '0');
                    final color = _statusColor(r.status);

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: color.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon(r.status), size: 12, color: color),
                          const SizedBox(width: 4),
                          Text(
                            "$rDay/$rMonth · ${_statusLabel(r.status)}",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
