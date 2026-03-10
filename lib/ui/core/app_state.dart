import 'package:flutter/material.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/repository/tag_repository.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/view_model/revision_cycle_view_model.dart';
import 'package:looply/view_model/tag_view_model.dart';
import 'package:looply/view_model/topic_view_model.dart';

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

    final result = await TopicViewModel(TopicRepository()).getAll();

    topics = result ?? [];
    
    isLoadingTopics = false;
    notifyListeners();
  }

  void getRevisionCycles() async {
    revisionCycles = await RevisionCycleViewModel(RevisionCycleRepository()).getAll();
    notifyListeners();
  }

  void chancePageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void getTags() async {
    tags = await TagViewModel(TagRepository()).getAll();
    notifyListeners();
  }

  void deleteTopic(int id) async {
    await TopicViewModel(TopicRepository()).delete(id);
    getTopics();
  }
}