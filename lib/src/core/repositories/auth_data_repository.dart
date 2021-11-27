import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/user/auth._data.dart';
import 'package:virtuallab/src/core/repositories/base_repository.dart';
import 'package:virtuallab/src/core/result.dart';

abstract class AuthDataRepository implements Repository {
  Future<Result<bool, Exception>> sendAuthData(AuthData data);
}

class AuthDataRepositoryImpl extends RequestRepository
    implements AuthDataRepository {
  AuthDataRepositoryImpl(
    this.client, {
    this.mapper = const AuthDataMapper(),
    this.codec = const JsonCodec(),
  });

  final AuthDataMapper mapper;
  final DefaultIOClient client;
  final JsonCodec codec;

  @override
  Future<Result<bool, Exception>> sendAuthData(AuthData data) async {
    final uri = requestUri(LabApiRequest.auth);

    final response = await client.post(uri, body: mapper.toJson(data));

    if (response.statusCode != HttpStatus.ok) throw 'Send user data failed';

    return const Result.success(true);
  }

  @override
  FutureOr onDispose() {
    // TODO: implement onDispose
    throw UnimplementedError();
  }
}
