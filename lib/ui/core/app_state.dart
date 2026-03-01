import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/service/revision_cycle_service.dart';
import 'package:looply/service/tag_service.dart';
import 'package:looply/service/topic_service.dart';

class AppState extends ChangeNotifier{
  int currentPageIndex = 0;

  List<Topic> topics = [];
  var revisionCycles;
  var tags;

  bool isLoadingTopics = true;

  void atualizar() {
    notifyListeners();
  }

  Future<void> getTopics() async{
    isLoadingTopics = true;
    notifyListeners();

    final result = await TopicService.instance.getAll();

    topics = result ?? [];
    
    isLoadingTopics = false;
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