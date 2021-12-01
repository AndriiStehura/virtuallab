import 'dart:convert';

class AuthData {
  final String email;
  final String passwordHash;

  const AuthData({
    required this.email,
    required this.passwordHash,
  });

  AuthData copyWith({
    String? email,
    String? passwordHash,
  }) {
    return AuthData(
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      email: map['email'],
      passwordHash: map['passwordHash'],
    );
  }

  @override
  String toString() => 'AuthData(email: $email, passwordHash: $passwordHash)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthData &&
        other.email == email &&
        other.passwordHash == passwordHash;
  }

  @override
  int get hashCode => email.hashCode ^ passwordHash.hashCode;
}

class AuthDataMapper {
  String toJson(AuthData object) => json.encode(object.toMap());

  AuthData fromJson(String source) => AuthData.fromMap(json.decode(source));

  const AuthDataMapper();
}
