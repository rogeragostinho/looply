import 'package:looply/model/revision_cycle.dart';

class RevisionCycleService {
  List<RevisionCycle> list = [];

  RevisionCycleService._privateConstructor() {
    list.add(RevisionCycle(1, "Default", [1, 7, 30, 60]));
  }

  static final RevisionCycleService _instance = RevisionCycleService._privateConstructor();

  static RevisionCycleService get instance => _instance;

  void create(String name, List<int> cycles) {
    int id = list.length+1;

    list.add(RevisionCycle(id, name, cycles));
  }

  RevisionCycle get(int id) {
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return list.firstWhere((e) => e.id == 1);
    }
  }

  List<RevisionCycle> getAll() {
    return list;
  }

  void remove(int id) {
    try {
      list.removeWhere((e) => e.id == id);
    } catch (_) { 
      return;
    }
  }

  void removeAll() {
    list = [];
  }
}