import 'package:flutter/foundation.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';

import '../result.dart';

abstract class AuthService {
  Future<Result<bool, Exception>> login(AuthData data);
  Future<Result<bool, Exception>> register(AuthData data);
  Future<Result<bool, Exception>> signOut(AuthData data);
}

class AuthServiceImpl implements AuthService {
  const AuthServiceImpl({
    required AuthDataRepository authDataRepository,
  }) : _repository = authDataRepository;

  final AuthDataRepository _repository;

  @override
  Future<Result<bool, Exception>> login(AuthData data) async {
    final result = await _repository.auth(data);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> register(AuthData data) async {
    final result = await _repository.register(data);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> signOut(AuthData data) async {
    final result = await _repository.signOut(data);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }
}
