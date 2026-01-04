import 'dart:convert';

class Revision {
  DateTime date;
  Status status;

  Revision({required this.date, required this.status});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'status': status.name,
  };

  factory Revision.fromJson(Map<String, dynamic> json) {
    return Revision(
      date: DateTime.parse(json['date']),
      status: Status.values.byName(json['status']),
    );
  }
}

enum Status {pendente, feito, naoFeito}