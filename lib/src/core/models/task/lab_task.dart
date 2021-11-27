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
  final int allowedChecks;
  LabTask({
    required this.id,
    required this.description,
    required this.answer,
    required this.complexity,
    required this.themeId,
    required this.theme,
    required this.allowedChecks,
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
      allowedChecks: allowedChecks ?? this.allowedChecks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'answer': answer,
      'themeId': themeId,
      'theme': theme.toMap(),
      'allowedChecks': allowedChecks,
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
      allowedChecks: map['allowedChecks'],
    );
  }

  @override
  String toString() {
    return 'LabTask(id: $id, description: $description, answer: $answer, complexity: $complexity, themeId: $themeId, theme: $theme, allowedChecks: $allowedChecks)';
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
        other.theme == theme &&
        other.allowedChecks == allowedChecks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        answer.hashCode ^
        complexity.hashCode ^
        themeId.hashCode ^
        theme.hashCode ^
        allowedChecks.hashCode;
  }
}

class LabTaskMapper {
  String toJson(LabTask object) => json.encode(object.toMap());

  LabTask fromJson(String source) => LabTask.fromMap(json.decode(source));
}
