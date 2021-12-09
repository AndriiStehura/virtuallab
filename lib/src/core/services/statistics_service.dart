import 'dart:async';

import 'package:flutter/material.dart';

import 'package:virtuallab/src/core/models/task/task_statistics.dart';
import 'package:virtuallab/src/core/repositories/statistics_repository.dart';

import '../result.dart';

abstract class StatisticsService {
  Future<Result<List<TaskStatistics>, Exception>> getStatistics(int id);
}

class StatisticsServiceImpl implements StatisticsService {
  StatisticsServiceImpl({required StatisticsRepository repository}) : _repository = repository;

  final StatisticsRepository _repository;

  @override
  Future<Result<List<TaskStatistics>, Exception>> getStatistics(int id) async {
    final result = await _repository.getStatistics(id);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }
}
