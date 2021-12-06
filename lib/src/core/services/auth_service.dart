import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';
import 'package:virtuallab/src/core/utils/string.dart';

import '../result.dart';

abstract class AuthService {
  Future<Result<bool, Exception>> login(AuthData data);
  Future<Result<bool, Exception>> register(User data);
  Future<Result<bool, Exception>> signOut(AuthData data);

  Future<Result<bool, Exception>> tryAutologin();

  User? get currentUser;
}

class AuthServiceImpl implements AuthService {
  User? _user;

  User? get currentUser => _user;

  AuthServiceImpl({
    required AuthDataRepository authDataRepository,
  }) : _repository = authDataRepository;

  final AuthDataRepository _repository;

  @override
  Future<Result<bool, Exception>> login(AuthData data) async {
    final result = await _repository.auth(data);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
      return Result.failed(Exception((result.exception.toString())));
    }

    save(data.email, data.passwordHash);

    _user = result.value;
    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> register(User data) async {
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

    invalidate();

    return result;
  }

  final Storage _localStorage = window.localStorage;

  @override
  Future<Result<bool, Exception>> tryAutologin() async {
    final authData = await getAuthData();

    final Result<bool, Exception> result;
    if (authData != null) {
      result = await login(authData);
    } else {
      result = Result.failed(Exception('Autoauth failed'));
    }

    return result;
  }

  Future save(String email, String password) async {
    _localStorage['email'] = email;
    _localStorage['password'] = password;
  }

  Future<AuthData?> getAuthData() async {
    final email = _localStorage['email'];
    final password = _localStorage['password'];

    if (email.isBlank || password.isBlank) {
      return null;
    }

    return AuthData(email: email!, passwordHash: password!);
  }

  Future invalidate() async {
    _localStorage.remove('email');
    _localStorage.remove('password');
  }
}
