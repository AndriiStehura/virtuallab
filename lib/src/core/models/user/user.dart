import 'dart:convert';

import 'identity.dart';

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String group;
  final int identityId;
  final Identity identity;
  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.group,
    required this.identityId,
    required this.identity,
  });

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? group,
    int? identityId,
    Identity? identity,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      group: group ?? this.group,
      identityId: identityId ?? this.identityId,
      identity: identity ?? this.identity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'group': group,
      'identityId': identityId,
      'identity': identity.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      group: map['group'],
      identityId: map['identityId'],
      identity: Identity.fromMap(map['identity']),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, group: $group, identityId: $identityId, identity: $identity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.group == group &&
        other.identityId == identityId &&
        other.identity == identity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        group.hashCode ^
        identityId.hashCode ^
        identity.hashCode;
  }
}

class UserMapper {
  String toJson(User object) => json.encode(object.toMap());

  User fromJson(String source) => User.fromMap(json.decode(source));
}
