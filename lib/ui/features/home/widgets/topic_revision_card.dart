import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/confirm_dialog.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/router/app_routes.dart';
import 'package:provider/provider.dart';
 
class TopicRevisionCard extends StatelessWidget {
  final TopicRevision topicRevision;
 
  const TopicRevisionCard({super.key, required this.topicRevision});
 
  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topic = topicRevision.topic;
    final revision = topicRevision.revision;
 
    final studiedDay = topic.studiedOn.day.toString().padLeft(2, '0');
    final studiedMonth = topic.studiedOn.month.toString().padLeft(2, '0');
    final revDay = revision.date.day.toString().padLeft(2, '0');
    final revMonth = revision.date.month.toString().padLeft(2, '0');
 
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.topicDetail, extra: topic.id!),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cabeçalho: primeira tag + data de início ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (topic.tags.isNotEmpty)
                    Chip(
                      label: Text(topic.tags.first.name),
                      labelStyle: theme.textTheme.labelSmall,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Iniciado em $studiedDay/$studiedMonth",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
 
              const SizedBox(height: 10),
 
              // ── Nome do tópico ────────────────────────────
              Text(
                topic.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
 
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
 
              // ── Rodapé: data de revisão + botão ──────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.repeat_rounded,
                        size: 15,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Revisão: $revDay/$revMonth",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: "Marcar revisão como feita",
                      );
                      if (!confirmed) return;
 
                      topicVM.markRevisionDone(topic, revision);
                    },
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text("Feito"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 