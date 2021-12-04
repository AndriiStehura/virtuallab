import 'dart:convert';

import 'package:virtuallab/src/core/models/task/lab_task.dart';

class Theme {
  final int id;
  final String name;

  Theme({
    required this.id,
    required this.name,
  });

  Theme copyWith({
    int? id,
    String? name,
    List<LabTask>? tasks,
  }) {
    return Theme(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Theme.fromMap(Map<String, dynamic> map) {
    return Theme(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() => 'Theme(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Theme && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class ThemeMapper {
  const ThemeMapper();

  String toJson(Theme object) => json.encode(object.toMap());

  Theme fromJson(String source) => Theme.fromMap(json.decode(source));

  List<Theme> fromJsonList(String source) {
    final data = json.decode(source);

    return data.map((e) => Theme.fromMap(e)).toList();
  }
}
