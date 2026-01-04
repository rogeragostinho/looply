import 'package:looply/model/revision.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/model/tag.dart';
import 'package:looply/model/topic.dart';

class TopicService {
  //TopicRepository? repository;
  //TopicService() : repository = TopicRepository();

  /*final */List<Topic> list = [];

  TopicService._privateConstructor();

  static final TopicService _instance = TopicService._privateConstructor();

  static TopicService get instance => _instance;

  void create({required String name, required DateTime studiedOn, required RevisionCycle revisionCycle, required List<Tag> tags}) {

    int id = list.isEmpty ? 1 : list.length + 1;
    List<Revision> revisions = [];

    for (int i = 0; i < revisionCycle.cycle.length; i++) {
      revisions.add(Revision(
        date: studiedOn.add(Duration(days: revisionCycle.cycle.elementAt(i))),
        status: Status.pendente
      ));
    }

    list.add(Topic(id, name, revisionCycle, tags, studiedOn, revisions));
  }

  List<Topic> getAll() {
    return list;
  }

  Topic get(int id) {
    return list.elementAt(id);
  }

  void remove(int id) {
    list.removeAt(id);
  }

  void removeAll() {
  list = [];
}
}

