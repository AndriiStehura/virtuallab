import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/services/task_service.dart';
import 'package:virtuallab/src/core/services/theme_service.dart';

class TaskSelectState {
  final bool isFetching;
  final bool hasError;
  final List<Theme> themes;

  TaskSelectState({
    required this.isFetching,
    required this.hasError,
    required this.themes,
  });

  TaskSelectState copyWith({
    bool? isFetching,
    bool? hasError,
    List<Theme>? themes,
    Complexity? complexity,
  }) {
    return TaskSelectState(
      isFetching: isFetching ?? this.isFetching,
      hasError: hasError ?? this.hasError,
      themes: themes ?? this.themes,
    );
  }

  @override
  String toString() {
    return 'TaskSelectState(isFetching: $isFetching, hasError: $hasError, themes: $themes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is TaskSelectState &&
        other.isFetching == isFetching &&
        other.hasError == hasError &&
        listEquals(other.themes, themes);
  }

  @override
  int get hashCode {
    return isFetching.hashCode ^ hasError.hashCode ^ themes.hashCode;
  }
}

abstract class TaskSelectBloc {
  ValueStream<TaskSelectState> get state;
  TaskSelectState get initial;

  Future<void> fetchThemes();
  Future<LabTask?> fetchTask(Theme theme, Complexity complexity);
}

class TaskSelectBlocImpl implements TaskSelectBloc {
  TaskSelectBlocImpl({required ThemeService themeService, required TaskService taskService})
      : _themeService = themeService,
        _taskService = taskService;

  final ThemeService _themeService;
  final TaskService _taskService;

  StreamSink<TaskSelectState> get sink => _subject.sink;

  final BehaviorSubject<TaskSelectState> _subject = BehaviorSubject<TaskSelectState>();

  @override
  Future<void> fetchThemes() async {
    sink.add(TaskSelectState(
      hasError: false,
      isFetching: true,
      themes: [],
    ));

    final result = await _themeService.getThemes();

    if (result.valueOrNull != null) {
      sink.add(TaskSelectState(
        hasError: false,
        isFetching: false,
        themes: result.value,
      ));
    } else {
      sink.add(TaskSelectState(
        hasError: true,
        isFetching: false,
        themes: [],
      ));
    }
  }

  @override
  Future<LabTask?> fetchTask(Theme theme, Complexity complexity) async {
    final result = await _taskService.getTaskByFilter(themeId: theme.id, complexity: complexity);

    if (result.exceptionOrNull != null) {
      return null;
    } else {
      return result.valueOrNull;
    }
  }

  @override
  TaskSelectState get initial => TaskSelectState(
        hasError: false,
        isFetching: true,
        themes: [],
      );

  @override
  ValueStream<TaskSelectState> get state => _subject.stream;
}
