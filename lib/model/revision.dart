import '../core/enums/revision_status.dart';

class Revision {
  DateTime date;
  RevisionStatus status;

  Revision({required this.date, required this.status});

  // METODOS

  //


  // =====================================
  // =============== JSON ================
  // =====================================
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'status': status.name,
  };

  factory Revision.fromJson(Map<String, dynamic> json) {
    return Revision(
      date: DateTime.parse(json['date']),
      status: RevisionStatus.values.byName(json['status']),
    );
  }
}