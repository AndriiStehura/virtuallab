import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/models/task/answer.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/grade.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/repositories/base_repository.dart';
import 'package:virtuallab/src/core/result.dart';
import 'package:virtuallab/src/core/utils/try_parse_utils.dart';

import '../default_io_client.dart';

abstract class TaskRepository implements Repository {
  Future<Result<List<LabTask>, Exception>> getTasks();
  Future<Result<LabTask, Exception>> getTask(int id);
  Future<Result<LabTask, Exception>> getTaskByFilter({
    required int themeId,
    required Complexity complexity,
  });
  Future<Result<bool, Exception>> updateTask(LabTask task);
  Future<Result<bool, Exception>> createTask(LabTask task);
  Future<Result<bool, Exception>> deleteTask(int id);
  Future<Result<Grade, Exception>> checkAnswer(Answer answer);
}

class TaskRepositoryImpl extends RequestRepository implements TaskRepository {
  TaskRepositoryImpl(
    this.client, {
    this.mapper = const LabTaskMapper(),
    this.answerMapper = const AnswerMapper(),
    this.codec = const JsonCodec(),
  });

  final DefaultIOClient client;
  final LabTaskMapper mapper;
  final AnswerMapper answerMapper;
  final JsonCodec codec;

  @override
  Future<Result<Grade, Exception>> checkAnswer(Answer answer) async {
    final uri = requestUri(LabApiRequest.checkAnswer);

    final body = answerMapper.toJson(answer);

    final response = await client.post(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Check answer failed'));

    final data = codec.decode(response.body);

    final grade = tryParseDouble(data['rightInPercent']);
    final rightAnswer = data['rightAnswer'];

    if (grade == null) return Result.failed(Exception('received null value'));

    return Result.success(Grade(grade: grade, rightAnswer: rightAnswer));
  }

  @override
  Future<Result<bool, Exception>> createTask(LabTask task) async {
    final uri = requestUri(LabApiRequest.tasks);

    final body = mapper.toJson(task);
    final response = await client.post(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Create task failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<bool, Exception>> deleteTask(int id) async {
    final uri = requestUri(LabApiRequest.tasks, parameters: {'id': '$id'});

    final response = await client.delete(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get task failed'));

    return const Result.success(true);
  }

  @override
  Future<Result<LabTask, Exception>> getTask(int id) async {
    final uri = requestUri(LabApiRequest.tasks, parameters: {'id': '$id'});

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get task failed id : $id'));

    final data = mapper.fromJson(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<LabTask, Exception>> getTaskByFilter({required int themeId, required Complexity complexity}) async {
    final uri = requestUri(LabApiRequest.taskByFilter, queryParameters: {
      'ThemeId': '$themeId',
      'Complexity': complexity.toFilter(),
    });

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) {
      return Result.failed(
        Exception('Get task failed  themeid: $themeId, complexity: ${complexity.toFilter()}'),
      );
    }

    final data = mapper.fromJson(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<List<LabTask>, Exception>> getTasks() async {
    final uri = requestUri(LabApiRequest.tasks);

    final response = await client.get(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Get tasks failed'));

    final data = mapper.fromJsonList(response.body);

    return Result.success(data);
  }

  @override
  Future<Result<bool, Exception>> updateTask(LabTask task) async {
    final uri = requestUri(LabApiRequest.tasks);

    final body = mapper.toJson(task);
    final response = await client.put(uri, body: body);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Update tasks failed'));

    return const Result.success(true);
  }

  @override
  FutureOr onDispose() {
    client.close();
  }
}

extension on Complexity {
  String toFilter() => '$index';
}
