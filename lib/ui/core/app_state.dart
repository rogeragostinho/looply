import 'package:flutter/material.dart';
import 'package:looply/service/revision_cycle_service.dart';
import 'package:looply/service/tag_service.dart';
import 'package:looply/service/topic_service.dart';

class AppState extends ChangeNotifier{
  int currentPageIndex = 0;

  var topics;
  var revisionCycles;
  var tags;

  void atualizar() {
    notifyListeners();
  }

  void getTopics() async{
    topics = await TopicService.instance.getAll();
    notifyListeners();
  }

  void getRevisionCycles() async {
    revisionCycles = await RevisionCycleService.instance.getAll();
    notifyListeners();
  }

  void chancePageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void getTags() async {
    tags = await TagService.instance.getAll();
    notifyListeners();
  }

  void deleteTopic(int id) async {
    await TopicService.instance.delete(id);
    getTopics();
  }
}