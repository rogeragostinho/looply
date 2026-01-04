import 'package:flutter/material.dart';
import 'package:looply/service/topic_service.dart';

class AppState extends ChangeNotifier{
  int currentPageIndex = 0;

  var topics;

  void getTopics() async{
    topics = await TopicService.instance.getAll();
    notifyListeners();
  }

  void chancePageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}