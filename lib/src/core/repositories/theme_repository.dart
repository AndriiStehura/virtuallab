import 'dart:convert';
import 'dart:io';

import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/repositories/base_repository.dart';
import 'package:virtuallab/src/core/result.dart';

abstract class ThemeRepository implements Repository {
  Future<Result<List<Theme>, Exception>> getThemes();
  Future<Result<Theme, Exception>> getTheme(int id);
  Future<Result<bool, Exception>> addTheme(Theme theme);
  Future<Result<bool, Exception>> updateTheme(Theme theme);
  Future<Result<bool, Exception>> delete(int id);
}

class ThemeRepositoryImpl extends RequestRepository implements ThemeRepository {
  ThemeRepositoryImpl(
    this.client, {
    this.mapper = const ThemeMapper(),
    this.codec = const JsonCodec(),
  });

  final DefaultIOClient client;
  final ThemeMapper mapper;

  final JsonCodec codec;

  @override
  Future<Result<List<Theme>, Exception>> getThemes() async {
    final uri = requestUri(LabApiRequest.themes);

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get themes failed'));

    final data = mapper.fromJsonList(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<Theme, Exception>> getTheme(int id) async {
    final uri = requestUri(LabApiRequest.themes, parameters: {'id': '$id'});

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get themes failed'));

    final data = mapper.fromJson(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<bool, Exception>> addTheme(Theme theme) async {
    final uri = requestUri(LabApiRequest.themes);

    final body = mapper.toJson(theme);

    final response = await client.post(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get themes failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> updateTheme(Theme theme) async {
    final uri = requestUri(LabApiRequest.themes);

    final body = mapper.toJson(theme);

    final response = await client.put(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get themes failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> delete(int id) async {
    final uri = requestUri(LabApiRequest.themes, parameters: {'id': '$id'});

    final response = await client.delete(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Delete theme failed'));

    return const Result.success(true);
  }
}
