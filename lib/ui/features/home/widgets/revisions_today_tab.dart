import 'package:flutter/material.dart';
import 'package:looply/ui/features/home/widgets/topic_revision_card.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
 
class RevisionsTodayTab extends StatefulWidget {
  const RevisionsTodayTab({super.key});
 
  @override
  State<RevisionsTodayTab> createState() => _RevisionsTodayTabState();
}
 
class _RevisionsTodayTabState extends State<RevisionsTodayTab> {
  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final todayTopicRevisions = topicVM.getTodayRevisions();
 
    if (topicVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
 
    if (todayTopicRevisions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            ),
            const SizedBox(height: 16),
            Text(
              "Sem revisões para hoje",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.45),
                  ),
            ),
          ],
        ),
      );
    }
 
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: todayTopicRevisions.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == todayTopicRevisions.length) {
          return const SizedBox(height: 56);
        }
        return TopicRevisionCard(topicRevision: todayTopicRevisions[index]);
      },
    );
  }
}