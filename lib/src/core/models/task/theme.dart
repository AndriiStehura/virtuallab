import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';

class Theme {
  final int id;
  final String name;
  final List<LabTask>? tasks;
  Theme({
    required this.id,
    required this.name,
    this.tasks,
  });

  Theme copyWith({
    int? id,
    String? name,
    List<LabTask>? tasks,
  }) {
    return Theme(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tasks': tasks?.map((x) => x.toMap()).toList(),
    };
  }

  factory Theme.fromMap(Map<String, dynamic> map) {
    return Theme(
      id: map['id'],
      name: map['name'],
      tasks: map['tasks'] != null
          ? List<LabTask>.from(map['tasks']?.map((x) => LabTask.fromMap(x)))
          : null,
    );
  }

  @override
  String toString() => 'Theme(id: $id, name: $name, tasks: $tasks)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Theme &&
        other.id == id &&
        other.name == name &&
        listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tasks.hashCode;
}

class ThemeMapper {
  String toJson(Theme object) => json.encode(object.toMap());

  Theme fromJson(String source) => Theme.fromMap(json.decode(source));
}
