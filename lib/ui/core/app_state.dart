import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
  int currentPageIndex = 0;

  void chancePageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}