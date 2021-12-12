import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/result.dart';
import 'package:virtuallab/src/core/services/task_service.dart';
import 'package:virtuallab/src/core/services/theme_service.dart';

class AdminTaskListState {
  final bool hasError;
  final bool isFetching;
  final List<LabTask>? tasks;
  final List<Theme>? themes;
  AdminTaskListState({
    required this.hasError,
    required this.isFetching,
    this.tasks,
    this.themes,
  });

  AdminTaskListState copyWith({
    bool? hasError,
    bool? isFetching,
    List<LabTask>? tasks,
    List<Theme>? themes,
  }) {
    return AdminTaskListState(
      hasError: hasError ?? this.hasError,
      isFetching: isFetching ?? this.isFetching,
      tasks: tasks ?? this.tasks,
      themes: themes ?? this.themes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hasError': hasError,
      'isFetching': isFetching,
      'tasks': tasks?.map((x) => x.toMap()).toList(),
      'themes': themes?.map((x) => x.toMap()).toList(),
    };
  }

  factory AdminTaskListState.fromMap(Map<String, dynamic> map) {
    return AdminTaskListState(
      hasError: map['hasError'] ?? false,
      isFetching: map['isFetching'] ?? false,
      tasks: map['tasks'] != null ? List<LabTask>.from(map['tasks']?.map((x) => LabTask.fromMap(x))) : null,
      themes: map['themes'] != null ? List<Theme>.from(map['themes']?.map((x) => Theme.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminTaskListState.fromJson(String source) => AdminTaskListState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdminTaskListState(hasError: $hasError, isFetching: $isFetching, tasks: $tasks, themes: $themes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is AdminTaskListState &&
        other.hasError == hasError &&
        other.isFetching == isFetching &&
        listEquals(other.tasks, tasks) &&
        listEquals(other.themes, themes);
  }

  @override
  int get hashCode {
    return hasError.hashCode ^ isFetching.hashCode ^ tasks.hashCode ^ themes.hashCode;
  }
}

abstract class AdminTaskListBloc {
  ValueStream<AdminTaskListState> get state;
  AdminTaskListState get initial;

  Future<Result<List<LabTask>, Exception>> _getTasks();
  Future<Result<List<Theme>, Exception>> _getThemes();

  Future<void> getData();

  Future<void> deleteTask(LabTask task);
}

class AdminTaskListBlocImpl implements AdminTaskListBloc {
  AdminTaskListBlocImpl({required TaskService taskService, required ThemeService themeService})
      : _taskService = taskService,
        _themeService = themeService;

  final TaskService _taskService;
  final ThemeService _themeService;

  List<LabTask>? _tasks;
  List<Theme>? _themes;

  @override
  ValueStream<AdminTaskListState> get state => _subject.stream;

  StreamSink<AdminTaskListState> get sink => _subject.sink;

  final BehaviorSubject<AdminTaskListState> _subject = BehaviorSubject<AdminTaskListState>();

  @override
  AdminTaskListState get initial => AdminTaskListState(hasError: false, isFetching: true, tasks: null);

  @override
  Future<Result<List<LabTask>, Exception>> _getTasks() async {
    final result = await _taskService.getTasks();
    if (result.valueOrNull != null) {
      _tasks = result.value;
    }

    return result;
  }

  @override
  Future<Result<List<Theme>, Exception>> _getThemes() async {
    final result = await _themeService.getThemes();

    if (result.valueOrNull != null) {
      _themes = result.value;
    }

    return result;
  }

  @override
  Future<void> getData() async {
    sink.add(AdminTaskListState(hasError: false, isFetching: true, tasks: _tasks, themes: _themes));

    final result = await Future.wait([_getTasks(), _getThemes()]);

    final hasError = result.any((element) => element.exceptionOrNull != null);

    sink.add(AdminTaskListState(hasError: hasError, isFetching: false, tasks: _tasks, themes: _themes));
  }

  @override
  Future<void> deleteTask(LabTask task) async {
    sink.add(AdminTaskListState(hasError: false, isFetching: true, tasks: _tasks, themes: _themes));

    final result = await _taskService.deleteTask(task.id);

    if (result.exceptionOrNull != null) {
      sink.add(AdminTaskListState(hasError: true, isFetching: false, tasks: _tasks, themes: _themes));
    } else {
      _tasks?.remove(task);
      sink.add(AdminTaskListState(hasError: false, isFetching: false, tasks: _tasks, themes: _themes));
    }
  }
}
