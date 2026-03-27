import 'package:flutter/foundation.dart';
import 'package:looply/model/revision.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/service/topic_service.dart';
import 'package:looply/utils/util.dart';
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

class TopicViewModel extends ChangeNotifier {
  final TopicService _service;

  List<Topic> topics = [];
  bool isLoading = true;

  // lista otimizada para consultas
  final List<TopicRevision> _topicRevisions = [];

  TopicViewModel(this._service);

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
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
    topics = await _service.getAll();
    _generateTopicRevisions();
    _setLoading(false);
  }

  // ================================
  // ********* CRUD *************
  // ================================

  Future<void> insert(Topic topic) async {
    await _service.insert(topic);
    await loadTopics();
  }

  Future<void> update(Topic topic) async {
    await _service.update(topic);
    await loadTopics();
  }

  Future<void> delete(int id) async {
    await _service.delete(id);
    await loadTopics();
  }

  // ================================
  // REVISION FILTERS
  // ================================

  List<TopicRevision> getTodayRevisions() {
    return _topicRevisions.where((tr) {
      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return Util.isSameDay(tr.revision.date, Util.todayDate());
    }).toList();
  }

  List<TopicRevision> getPendingRevisions() {
    final today = Util.todayDate();

    return _topicRevisions.where((tr) {
      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return tr.revision.date.isBefore(today) &&
          !Util.isSameDay(tr.revision.date, today);
    }).toList();
  }

  List<TopicRevision> getUpcomingRevisions() {
    return _topicRevisions.where((tr) {
      if (tr.revision.status == RevisionStatus.done) {
        return false;
      }

      return tr.revision.date.isAfter(Util.todayDate());
    }).toList();
  }

  Future<void> markRevisionDone(Topic topic, Revision revision) async {
    await _service.makRevisionDone(topic, revision);
    loadTopics();
    notifyListeners();
  }

  //==============================================
  // FUNÇÃO CHAMADA QUANDO O APP É ABERTO em MyApp
  //==============================================
  Future<void> updateStatus() async {
    await _service.updateStatus();
    loadTopics();
    notifyListeners();
  }
}
