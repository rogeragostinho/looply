import 'package:flutter/material.dart';

class Tag {
  int id;
  String name;
  int colorARGB;

  Tag(this.id, this.name, this.colorARGB);

  Color get color => Color(colorARGB);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorARGB': colorARGB,
  };

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json['id'],
      json['name'],
      json['colorARGB'],
    );
  }
}