//import 'package:looply/model/revision.dart';
import 'package:looply/model/revision.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/model/tag.dart';
import 'package:looply/model/topic.dart';
//import 'package:looply/model/topic.dart';
import 'package:looply/repository/topic_repository.dart';

class TopicService {
  TopicRepository? _repository;

  TopicService._privateConstructor() {
    _repository = TopicRepository();
  }

  static final TopicService _instance = TopicService._privateConstructor();

  static TopicService get instance => _instance;

  Future<void> create({
    required String name,
    required DateTime studiedOn,
    required RevisionCycle revisionCycle,
    required List<Tag> tags,
  }) async {
    final revisions = revisionCycle.cycle
        .map(
          (days) => Revision(
            date: studiedOn.add(Duration(days: days)),
            status: Status.pendente,
          ),
        )
        .toList();

    await _repository!.insertTopic(
      Topic(name, revisionCycle, tags, studiedOn, revisions),
    );
  }

  Future<List<Topic>> getAll() async {
    return await _repository!.getAllTopics();
  }

  Future<int> delete(int id) async {
    return await _repository!.delete(id);
  }

  /*Topic get(int id) {
    return list.elementAt(id);
  }

  void remove(int id) {
    list.removeAt(id);
  }

  void removeAll() {
  list = [];
}*/
}
