import 'package:looply/model/revision_cycle.dart';
import 'package:looply/repository/revision_cycle_repository.dart';

class RevisionCycleService {
  List<RevisionCycle> list = [];
  final RevisionCycle defaultRevisonCycle = RevisionCycle("default", [1, 7, 30, 90], id: 0);

  RevisionCycleService._privateConstructor() {
    list.add(RevisionCycle("Default", [1, 7, 30, 60]));
  }

  static final RevisionCycleService _instance = RevisionCycleService._privateConstructor();

  static RevisionCycleService get instance => _instance;

  void create(String name, List<int> cycle) {
    /*int id = list.length+1;

    list.add(RevisionCycle(id, name, cycles));*/

    var repository = RevisionCycleRepository();

    repository.create(RevisionCycle(name, cycle));
  }

  Future<RevisionCycle?> get(int id) async {
    /*try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return list.firstWhere((e) => e.id == 1);
    }*/
    var repository = RevisionCycleRepository();
    return await repository.getById(id);
  }

  Future<List<RevisionCycle>> getAll() async {
    var repository = RevisionCycleRepository();
    return await repository.getAll();
  }

  RevisionCycle getDefault() {
    return defaultRevisonCycle;
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