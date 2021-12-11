import 'dart:convert';

class Grade {
  final double grade;
  final String rightAnswer;
  Grade({
    required this.grade,
    required this.rightAnswer,
  });

  Grade copyWith({
    double? grade,
    String? rightAnswer,
  }) {
    return Grade(
      grade: grade ?? this.grade,
      rightAnswer: rightAnswer ?? this.rightAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grade': grade,
      'rightAnswer': rightAnswer,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      grade: map['grade']?.toDouble() ?? 0.0,
      rightAnswer: map['rightAnswer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Grade.fromJson(String source) => Grade.fromMap(json.decode(source));

  @override
  String toString() => 'Grade(grade: $grade, rightAnswer: $rightAnswer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Grade && other.grade == grade && other.rightAnswer == rightAnswer;
  }

  @override
  int get hashCode => grade.hashCode ^ rightAnswer.hashCode;
}
