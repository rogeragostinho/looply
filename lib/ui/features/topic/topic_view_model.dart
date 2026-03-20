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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
           a.month == b.month &&
           a.day == b.day;
  }

  void _generateTopicRevisions() {
    _topicRevisions.clear();

    for (var topic in topics) {
      for (var revision in topic.revisions!) {
        _topicRevisions.add(TopicRevision(topic, revision));
      }
    }
  }

  // ================================
  // LOAD
  // ================================

  Future<void> loadTopics() async {
    _setLoading(true);

    topics = await repository.getAll();

    _generateTopicRevisions();

    _setLoading(false);
  }

  // ================================
  // INSERT
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

  // ================================
  // UPDATE
  // ================================

  Future<void> update(Topic topic) async {
    await repository.update(topic);
    await loadTopics();
  }

  // ================================
  // DELETE
  // ================================

  Future<void> delete(int id) async {
    await repository.delete(id);
    await loadTopics();
  }

  // ================================
  // GET
  // ================================

  Topic? getTopicById(int id) {
    try {
      return topics.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
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

      return _isSameDay(tr.revision.date, today);

    }).toList();
  }

  List<TopicRevision> getOverdueRevisions() {
    final today = DateTime.now();

    return _topicRevisions.where((tr) {

      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return tr.revision.date.isBefore(today) &&
             !_isSameDay(tr.revision.date, today);

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

}