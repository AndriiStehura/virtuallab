import 'dart:convert';

class UpdateUser {
  final int id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? group;
  UpdateUser({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.group,
  });

  UpdateUser copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? group,
  }) {
    return UpdateUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'group': group,
    };
  }

  factory UpdateUser.fromMap(Map<String, dynamic> map) {
    return UpdateUser(
      id: map['id']?.toInt() ?? 0,
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      group: map['group'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUser.fromJson(String source) => UpdateUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateUser(id: $id, email: $email, firstName: $firstName, lastName: $lastName, group: $group)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateUser &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.group == group;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ group.hashCode;
  }
}
