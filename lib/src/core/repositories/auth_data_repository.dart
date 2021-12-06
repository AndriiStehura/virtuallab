// ignore_for_file: curly_braces_in_flow_control_structures, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/repositories/base_repository.dart';
import 'package:virtuallab/src/core/result.dart';

abstract class AuthDataRepository implements Repository {
  Future<Result<User, Exception>> auth(AuthData data);
  Future<Result<bool, Exception>> register(User data);
  Future<Result<bool, Exception>> signOut(AuthData data);
}

class AuthDataRepositoryImpl extends RequestRepository implements AuthDataRepository {
  AuthDataRepositoryImpl(
    this.client, {
    this.mapper = const AuthDataMapper(),
    this.userMapper = const UserMapper(),
    this.codec = const JsonCodec(),
  });

  final AuthDataMapper mapper;
  final UserMapper userMapper;
  final DefaultIOClient client;
  final JsonCodec codec;

  @override
  Future<Result<User, Exception>> auth(AuthData data) async {
    final uri = requestUri(LabApiRequest.auth);

    final response = await client.post(uri, body: mapper.toJson(data));

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Send user data failed'));

    final user = userMapper.fromJson(response.body);

    return Result.success(user);
  }

  @override
  Future<Result<bool, Exception>> register(User data) async {
    final uri = requestUri(LabApiRequest.register);

    final response = await client.post(uri, body: userMapper.toJson(data));

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Register failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> signOut(AuthData data) async {
    final uri = requestUri(LabApiRequest.signOut, parameters: {'email': data.email});

    final response = await client.post(uri, body: mapper.toJson(data));

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('SignOut failed'));

    return const Result.success(true);
  }

  @override
  FutureOr onDispose() {
    client.close();
  }
}
