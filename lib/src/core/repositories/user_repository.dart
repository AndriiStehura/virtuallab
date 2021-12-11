import 'dart:convert';
import 'dart:io';

import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/models/user/update_password.dart';
import 'package:virtuallab/src/core/models/user/update_user.dart';
import 'package:virtuallab/src/core/models/user/user.dart';

import '../default_io_client.dart';
import '../result.dart';
import 'base_repository.dart';

abstract class UserRepository implements Repository {
  Future<Result<List<User>, Exception>> getUsers();
  Future<Result<User, Exception>> getUser(int id);
  Future<Result<bool, Exception>> addUser(User user);
  Future<Result<bool, Exception>> updateUser(UpdateUser user);
  Future<Result<bool, Exception>> updatePassword(UpdatePassword password);
}

class UserRepositoryImpl extends RequestRepository implements UserRepository {
  UserRepositoryImpl(
    this.client, {
    this.mapper = const UserMapper(),
    this.codec = const JsonCodec(),
  });

  final DefaultIOClient client;
  final UserMapper mapper;

  final JsonCodec codec;

  @override
  Future<Result<List<User>, Exception>> getUsers() async {
    final uri = requestUri(LabApiRequest.users);

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get users failed'));

    final data = mapper.fromJsonList(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<User, Exception>> getUser(int id) async {
    final uri = requestUri(LabApiRequest.users, parameters: {'id': '$id'});

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get user failed'));

    final data = mapper.fromJson(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<bool, Exception>> addUser(User user) async {
    final uri = requestUri(LabApiRequest.users);

    final body = mapper.toJson(user);

    final response = await client.post(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get user failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> updateUser(UpdateUser user) async {
    final uri = requestUri(LabApiRequest.users);

    final body = user.toJson();

    final response = await client.put(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Update user failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> updatePassword(UpdatePassword password) async {
    final uri = requestUri(LabApiRequest.password);

    final body = password.toJson();

    final response = await client.put(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Update password failed'));

    return const Result.success(true);
  }
}
