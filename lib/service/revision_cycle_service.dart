import 'package:looply/model/revision_cycle.dart';
import 'package:looply/repository/revision_cycle_repository.dart';
import 'package:looply/service/abstract_service.dart';

class RevisionCycleService extends AbstractService<RevisionCycle, RevisionCycleRepository> {

  List<RevisionCycle> list = [];
  final RevisionCycle defaultRevisonCycle = RevisionCycle("default", [1, 7, 30, 90], id: 0);

  RevisionCycleService._privateConstructor() : super(RevisionCycleRepository.instance) {
    list.add(RevisionCycle("Default", [1, 7, 30, 60]));
  }

  // ============ SINGLETON ===============
  static final RevisionCycleService _instance = RevisionCycleService._privateConstructor();
  static RevisionCycleService get instance => _instance;
  // =====================================

  // ============ METODOS ==============
  void create(String name, List<int> cycle) {
    /*int id = list.length+1;

    list.add(RevisionCycle(id, name, cycles));*/

    repository.insert(RevisionCycle(name, cycle));
  }

  Future<RevisionCycle?> get(int id) async {
    return await repository.getById(id);
  }

  Future<List<RevisionCycle>> getAll() async {
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