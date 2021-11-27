import 'dart:convert';

class Identity {
  final int id;
  final String passwordHash;
  Identity({
    required this.id,
    required this.passwordHash,
  });

  Identity copyWith({
    int? id,
    String? passwordHash,
  }) {
    return Identity(
      id: id ?? this.id,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passwordHash': passwordHash,
    };
  }

  factory Identity.fromMap(Map<String, dynamic> map) {
    return Identity(
      id: map['id'],
      passwordHash: map['passwordHash'],
    );
  }

  @override
  String toString() => 'Identity(id: $id, passwordHash: $passwordHash)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Identity &&
        other.id == id &&
        other.passwordHash == passwordHash;
  }

  @override
  int get hashCode => id.hashCode ^ passwordHash.hashCode;
}

class IdentityMapper {
  String toJson(Identity object) => json.encode(object.toMap());

  Identity fromJson(String source) => Identity.fromMap(json.decode(source));
}
