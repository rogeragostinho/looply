import 'dart:convert';

class RevisionCycle {
  int? id;
  String name;
  List<int> cycle;

  RevisionCycle(this.name, this.cycle, {this.id});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic> {
      //'id': id,
      'name': name,
      'cycle_json': jsonEncode(cycle)
    };

    return map;
  }

  factory RevisionCycle.fromJson(Map<String, dynamic> json) {
  var cycleJson = json['cycle_json'];
  List<int> cycles = [];

  if (cycleJson != null) {
    cycles = List<int>.from(jsonDecode(cycleJson));
  }

  return RevisionCycle(
    json['name'] ?? '',
    cycles,
    id: json['id'],
  );
}

}