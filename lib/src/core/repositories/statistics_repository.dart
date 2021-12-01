import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/task/task_statistics.dart';
import 'package:virtuallab/src/core/repositories/base_repository.dart';

import '../result.dart';

abstract class StatisticsRepository implements Repository {
  Future<Result<TaskStatistics, Exception>> getStatistics(int id);
}

class StatisticsRepositoryImpl extends RequestRepository implements StatisticsRepository {
  StatisticsRepositoryImpl(
    this.client, {
    this.mapper = const TaskStatisticsMapper(),
    this.codec = const JsonCodec(),
  });

  final DefaultIOClient client;
  final TaskStatisticsMapper mapper;
  final JsonCodec codec;

  @override
  Future<Result<TaskStatistics, Exception>> getStatistics(int id) async {
    final uri = requestUri(LabApiRequest.statistics, parameters: {'id': '$id'});

    final response = await client.post(uri);

    if (response.statusCode != HttpStatus.ok) return Result.failed(Exception('Fetch statistics failed'));

    final data = mapper.fromJson(response.body);

    return Result.success(data);
  }

  @override
  FutureOr onDispose() {}
}
