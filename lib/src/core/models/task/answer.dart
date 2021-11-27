import 'dart:convert';

class Answer {
  final int taskId;
  final int userId;
  final String answer;
  Answer({
    required this.taskId,
    required this.userId,
    required this.answer,
  });

  Answer copyWith({
    int? taskId,
    int? userId,
    String? answer,
  }) {
    return Answer(
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'userId': userId,
      'answer': answer,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      taskId: map['taskId'],
      userId: map['userId'],
      answer: map['answer'],
    );
  }

  @override
  String toString() =>
      'Answer(taskId: $taskId, userId: $userId, answer: $answer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Answer &&
        other.taskId == taskId &&
        other.userId == userId &&
        other.answer == answer;
  }

  @override
  int get hashCode => taskId.hashCode ^ userId.hashCode ^ answer.hashCode;
}

class AnswerMapper {
  String toJson(Answer object) => json.encode(object.toMap());

  Answer fromJson(String source) => Answer.fromMap(json.decode(source));
}
