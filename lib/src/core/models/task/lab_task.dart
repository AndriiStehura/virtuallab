import 'dart:convert';

import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';

class LabTask {
  final int id;
  final String description;
  final String answer;
  final Complexity complexity;
  final int themeId;
  final Theme theme;

  LabTask({
    required this.id,
    required this.description,
    required this.answer,
    required this.complexity,
    required this.themeId,
    required this.theme,
  });

  LabTask copyWith({
    int? id,
    String? description,
    String? answer,
    Complexity? complexity,
    int? themeId,
    Theme? theme,
    int? allowedChecks,
  }) {
    return LabTask(
      id: id ?? this.id,
      description: description ?? this.description,
      answer: answer ?? this.answer,
      complexity: complexity ?? this.complexity,
      themeId: themeId ?? this.themeId,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'answer': answer,
      'themeId': themeId,
      'theme': theme.toMap(),
    };
  }

  factory LabTask.fromMap(Map<String, dynamic> map) {
    return LabTask(
      id: map['id'],
      description: map['description'],
      answer: map['answer'],
      complexity: ComplexityInit.init(map['complexity']),
      themeId: map['themeId'],
      theme: Theme.fromMap(map['theme']),
    );
  }

  @override
  String toString() {
    return 'LabTask(id: $id, description: $description, answer: $answer, complexity: $complexity, themeId: $themeId, theme: $theme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LabTask &&
        other.id == id &&
        other.description == description &&
        other.answer == answer &&
        other.complexity == complexity &&
        other.themeId == themeId &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        answer.hashCode ^
        complexity.hashCode ^
        themeId.hashCode ^
        theme.hashCode;
  }
}

class LabTaskMapper {
  const LabTaskMapper();

  String toJson(LabTask object) => json.encode(object.toMap());

  LabTask fromJson(String source) => LabTask.fromMap(json.decode(source));

  List<LabTask> fromListJson(Iterable<String> source) => source.map((e) => fromJson(e)).toList();
}
