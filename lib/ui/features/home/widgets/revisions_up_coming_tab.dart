import 'package:flutter/material.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:looply/ui/features/home/widgets/topic_revision_card.dart';
import 'package:provider/provider.dart';
 
class RevisionsUpComingTab extends StatelessWidget {
  const RevisionsUpComingTab({super.key});
 
  @override
  Widget build(BuildContext context) {
    final topicVM = context.watch<TopicViewModel>();
    final upComingTopicRevision = topicVM.getUpcomingRevisions();
 
    if (upComingTopicRevision.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            ),
            const SizedBox(height: 16),
            Text(
              "Sem revisões futuras",
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
      itemCount: upComingTopicRevision.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == upComingTopicRevision.length) {
          return const SizedBox(height: 56);
        }
        return TopicRevisionCard(topicRevision: upComingTopicRevision[index]);
      },
    );
  }
}