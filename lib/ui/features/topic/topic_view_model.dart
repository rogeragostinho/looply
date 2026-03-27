import 'package:looply/model/revision.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/core/view_model/abstract_view_model.dart';
import '../../../core/enums/revision_status.dart';

class TopicRevision {
  final Topic topic;
  final Revision revision;

  TopicRevision(this.topic, this.revision);
}

/*
final today = topicVM.getTodayRevisions();
final overdue = topicVM.getOverdueRevisions();
final upcoming = topicVM.getUpcomingRevisions();
*/

class TopicViewModel extends AbstractViewModel<Topic, TopicRepository> {
  List<Topic> topics = [];
  bool isLoading = true;

  // lista otimizada para consultas
  final List<TopicRevision> _topicRevisions = [];

  TopicViewModel(super.repository);

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // ================================
  // UTIL
  // ================================

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _generateTopicRevisions() {
    _topicRevisions.clear();

    for (var topic in topics) {
      for (var revision in topic.revisions!) {
        _topicRevisions.add(TopicRevision(topic, revision));
      }
    }
  }

  Future<void> loadTopics() async {
    _setLoading(true);

    topics = await repository.getAll();

    _generateTopicRevisions();

    _setLoading(false);
  }

  // ================================
  // ********* CRUD *************
  // ================================

  Future<void> insert(Topic topic) async {
    final revisions = topic.revisionCycle
        .map(
          (days) => Revision(
            date: topic.studiedOn.add(Duration(days: days)),
            status: RevisionStatus.upComing,
          ),
        )
        .toList();

    topic.revisions = revisions;

    await repository.insert(topic);

    await loadTopics();
  }

  Future<void> update(Topic topic) async {
    await repository.update(topic);
    await loadTopics();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await loadTopics();
  }

  // ================================
  // REVISION FILTERS
  // ================================

  List<TopicRevision> getTodayRevisions() {
    final today = DateTime.now();

    return _topicRevisions.where((tr) {
      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return isSameDay(tr.revision.date, today);
    }).toList();
  }

  List<TopicRevision> getOverdueRevisions() {
    final today = DateTime.now();

    return _topicRevisions.where((tr) {
      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return tr.revision.date.isBefore(today) &&
          !isSameDay(tr.revision.date, today);
    }).toList();
  }

  List<TopicRevision> getUpcomingRevisions() {
    final today = DateTime.now();

    return _topicRevisions.where((tr) {
      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return tr.revision.date.isAfter(today);
    }).toList();
  }

  Future<void> markRevisionDone(Topic topic, Revision revision) async {
    // marca a revisão
    revision.status = RevisionStatus.done;

    // atualiza o tópico no banco
    await repository.update(topic);

    // atualiza a lista interna de revisões para refletir a mudança
    _generateTopicRevisions();

    // notifica a UI
    notifyListeners();
  }

  //==============================================
  // FUNÇÃO CHAMADA QUANDO O APP É ABERTO em MyApp
  //==============================================

  Future<void> updateStatus() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

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
        await repository.update(
          topic,
        ); // atualiza o banco apenas 1 vez por topic
      }
    }

    notifyListeners();
  }
}
