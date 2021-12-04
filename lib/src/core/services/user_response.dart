import 'package:flutter/foundation.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/repositories/user_repository.dart';

import '../result.dart';

abstract class UserService {
  Future<Result<List<User>, Exception>> getUsers();
  Future<Result<User, Exception>> getUser(int id);
  Future<Result<bool, Exception>> addUser(User user);
  Future<Result<bool, Exception>> updateUser(User user);
}

class UserServiceImpl implements UserService {
  UserServiceImpl({
    required UserRepository repository,
  }) : _repository = repository;

  final UserRepository _repository;

  @override
  Future<Result<List<User>, Exception>> getUsers() async {
    final result = await _repository.getUsers();

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<User, Exception>> getUser(int id) async {
    final result = await _repository.getUser(id);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> addUser(User user) async {
    final result = await _repository.addUser(user);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> updateUser(User user) async {
    final result = await _repository.updateUser(user);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }
}
