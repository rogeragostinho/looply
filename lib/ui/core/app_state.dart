import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppState extends ChangeNotifier{
  int currentPageIndex = 0;

  void chancePageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}