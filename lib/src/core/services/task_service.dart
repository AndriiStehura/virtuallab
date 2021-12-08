import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virtuallab/src/core/models/task/answer.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/repositories/task_repository.dart';
import 'package:virtuallab/src/core/result.dart';

abstract class TaskService {
  Future<Result<List<LabTask>, Exception>> getTasks();
  Future<Result<LabTask, Exception>> getTask(int id);
  Future<Result<LabTask, Exception>> getTaskByFilter({
    required int themeId,
    required Complexity complexity,
  });
  Future<Result<bool, Exception>> updateTask(LabTask task);
  Future<Result<bool, Exception>> createTask(LabTask task);
  Future<Result<bool, Exception>> deleteTask(int id);
  Future<Result<double, Exception>> checkAnswer(Answer answer);
}

class TaskServiceImpl implements TaskService {
  TaskServiceImpl({required TaskRepository repository}) : _repository = repository;

  final TaskRepository _repository;

  @override
  Future<Result<double, Exception>> checkAnswer(Answer answer) async {
    final result = await _repository.checkAnswer(answer);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> createTask(LabTask task) async {
    final result = await _repository.createTask(task);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> deleteTask(int id) async {
    final result = await _repository.deleteTask(id);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<LabTask, Exception>> getTask(int id) async {
    final result = await _repository.getTask(id);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<LabTask, Exception>> getTaskByFilter({
    required int themeId,
    required Complexity complexity,
  }) async {
    final result = await _repository.getTaskByFilter(themeId: themeId, complexity: complexity);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<List<LabTask>, Exception>> getTasks() async {
    final result = await _repository.getTasks();

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> updateTask(LabTask task) async {
    final result = await _repository.updateTask(task);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }
}
