import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/model/revision.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/utils/util.dart';

class TopicService {
  final TopicRepository _repository;

  TopicService(this._repository);

  Future<int> insert(Topic topic) async {
    final revisions = topic.revisionCycle
        .map(
          (days) => Revision(
            date: topic.studiedOn.add(Duration(days: days)),
            status: RevisionStatus.upComing,
          ),
        )
        .toList();

    topic.revisions = revisions;

    await _checkPendingReviewsNewTopic(topic);
    return await _repository.insert(topic);
  }

  Future<int> update(Topic topic) async {
    return await _repository.update(topic);
  }

  Future<int> delete(int id) async {
    return await _repository.delete(id);
  }

  Future<List<Topic>> getAll() async {
    return await _repository.getAll();
  }

  // ===================================
  // ======== FUNÇÕES INTERNAS =========
  // ===================================

  // FUNÇÃO QUE VERIFICA SE UM TOPICO ADICIONADO AGORA TEM REVISÕES PENDENTES
  Future<void> _checkPendingReviewsNewTopic(Topic topic) async {
    if (topic.studiedOn.isBefore(Util.todayDate())) {
      for (int i = 0; i < topic.revisions!.length; i++) {
        final revision = topic.revisions![i];

        if (revision.date.isBefore(Util.todayDate()) &&
            revision.status != RevisionStatus.done) {
          revision.status = RevisionStatus.pending;
        }
      }
    }
  }

  Future<int> makRevisionDone(Topic topic, Revision revision) async {
    revision.status = RevisionStatus.done;
    return await _repository.update(topic);
  }

  Future<void> updateStatus() async {
    List<Topic> topics = await _repository.getAll();

    final today = Util.todayDate();

    for (var topic in topics) {

      bool topicChanged = false;

      for (int i = 0; i < topic.revisions!.length; i++) {
        final revision = topic.revisions![i];
        final revisionDate = DateTime(
          revision.date.year,
          revision.date.month,
          revision.date.day,
        );

        if (revisionDate.isBefore(today) &&
            revision.status != RevisionStatus.done &&
            revision.status != RevisionStatus.pending) {
          topic.revisions![i].status = RevisionStatus.pending;
          topicChanged = true;
        }

        if (revisionDate.isAfter(today) &&
            revision.status != RevisionStatus.done &&
            revision.status != RevisionStatus.upComing) {
          topic.revisions![i].status = RevisionStatus.upComing;
          topicChanged = true;
        }
      }

      if (topicChanged) {
        await _repository.update(topic);
      }
    }
  }
}
