import 'dart:convert';

class RevisionCycle {
  int id;
  String name;
  List<int> cycle;

  RevisionCycle(this.id, this.name, this.cycle);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic> {
      'id': id,
      'name': name,
      'cycle': jsonEncode(cycle)
    };

    return map;
  }

  factory RevisionCycle.fromJson(Map<String, dynamic> json) {
    return RevisionCycle(
      json['id'],
      json['name'],
      List<int>.from(jsonDecode(json['cycle'])),
    );
  }
}