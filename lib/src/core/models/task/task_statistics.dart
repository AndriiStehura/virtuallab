import 'dart:convert';

import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/user/user.dart';

class TaskStatistics {
  final int id;
  final int userId;
  final User user;
  final int taskId;
  final LabTask task;
  final double grade;
  TaskStatistics({
    required this.id,
    required this.userId,
    required this.user,
    required this.taskId,
    required this.task,
    required this.grade,
  });

  TaskStatistics copyWith({
    int? id,
    int? userId,
    User? user,
    int? taskId,
    LabTask? task,
    double? grade,
  }) {
    return TaskStatistics(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      taskId: taskId ?? this.taskId,
      task: task ?? this.task,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'user': user.toMap(),
      'taskId': taskId,
      'task': task.toMap(),
      'grade': grade,
    };
  }

  factory TaskStatistics.fromMap(Map<String, dynamic> map) {
    return TaskStatistics(
      id: map['id'],
      userId: map['userId'],
      user: User.fromMap(map['user']),
      taskId: map['taskId'],
      task: LabTask.fromMap(map['task']),
      grade: map['grade'],
    );
  }

  @override
  String toString() {
    return 'TaskStatistics(id: $id, userId: $userId, user: $user, taskId: $taskId, task: $task, grade: $grade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskStatistics &&
        other.id == id &&
        other.userId == userId &&
        other.user == user &&
        other.taskId == taskId &&
        other.task == task &&
        other.grade == grade;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ user.hashCode ^ taskId.hashCode ^ task.hashCode ^ grade.hashCode;
  }
}

class TaskStatisticsMapper {
  const TaskStatisticsMapper();

  String toJson(TaskStatistics object) => json.encode(object.toMap());

  TaskStatistics fromJson(String source) => TaskStatistics.fromMap(json.decode(source));
}
