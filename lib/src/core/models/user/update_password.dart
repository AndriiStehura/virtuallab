import 'dart:convert';

class UpdatePassword {
  final int userId;
  final String? password;
  UpdatePassword({
    required this.userId,
    this.password,
  });

  UpdatePassword copyWith({
    int? userId,
    String? password,
  }) {
    return UpdatePassword(
      userId: userId ?? this.userId,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'password': password,
    };
  }

  factory UpdatePassword.fromMap(Map<String, dynamic> map) {
    return UpdatePassword(
      userId: map['userId']?.toInt() ?? 0,
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatePassword.fromJson(String source) => UpdatePassword.fromMap(json.decode(source));

  @override
  String toString() => 'UpdatePassword(userId: $userId, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdatePassword && other.userId == userId && other.password == password;
  }

  @override
  int get hashCode => userId.hashCode ^ password.hashCode;
}
