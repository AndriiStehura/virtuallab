import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/services/task_service.dart';
import 'package:virtuallab/src/core/services/theme_service.dart';

class TaskCreationState {
  final bool isFetching;
  final bool hasError;
  final bool isSaved;
  final bool? addThemeSuccess;
  final List<Theme> themes;
  TaskCreationState({
    required this.isFetching,
    required this.hasError,
    required this.isSaved,
    this.addThemeSuccess,
    required this.themes,
  });

  TaskCreationState copyWith({
    bool? isFetching,
    bool? hasError,
    bool? isSaved,
    bool? addThemeSuccess,
    List<Theme>? themes,
  }) {
    return TaskCreationState(
      isFetching: isFetching ?? this.isFetching,
      hasError: hasError ?? this.hasError,
      isSaved: isSaved ?? this.isSaved,
      addThemeSuccess: addThemeSuccess ?? this.addThemeSuccess,
      themes: themes ?? this.themes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isFetching': isFetching,
      'hasError': hasError,
      'isSaved': isSaved,
      'addThemeSuccess': addThemeSuccess,
      'themes': themes.map((x) => x.toMap()).toList(),
    };
  }

  factory TaskCreationState.fromMap(Map<String, dynamic> map) {
    return TaskCreationState(
      isFetching: map['isFetching'] ?? false,
      hasError: map['hasError'] ?? false,
      isSaved: map['isSaved'] ?? false,
      addThemeSuccess: map['addThemeSuccess'],
      themes: List<Theme>.from(map['themes']?.map((x) => Theme.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskCreationState.fromJson(String source) => TaskCreationState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskCreationState(isFetching: $isFetching, hasError: $hasError, isSaved: $isSaved, addThemeSuccess: $addThemeSuccess, themes: $themes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is TaskCreationState &&
        other.isFetching == isFetching &&
        other.hasError == hasError &&
        other.isSaved == isSaved &&
        other.addThemeSuccess == addThemeSuccess &&
        listEquals(other.themes, themes);
  }

  @override
  int get hashCode {
    return isFetching.hashCode ^ hasError.hashCode ^ isSaved.hashCode ^ addThemeSuccess.hashCode ^ themes.hashCode;
  }
}

abstract class TaskCreationBloc {
  ValueStream<TaskCreationState> get state;
  TaskCreationState get initial;

  Future<void> getThemes();
  Future<void> submitTask(LabTask task);
  Future<void> updateTask(LabTask task);
  Future<void> submitTheme(String themeName);
}

class TaskCreationBlocImpl implements TaskCreationBloc {
  TaskCreationBlocImpl({required ThemeService themeService, required TaskService taskService})
      : _taskService = taskService,
        _themeService = themeService;

  final ThemeService _themeService;
  final TaskService _taskService;

  List<Theme> _themes = [];

  @override
  ValueStream<TaskCreationState> get state => _subject.stream;

  StreamSink<TaskCreationState> get sink => _subject.sink;

  final BehaviorSubject<TaskCreationState> _subject = BehaviorSubject<TaskCreationState>();

  @override
  TaskCreationState get initial => TaskCreationState(hasError: false, isSaved: false, isFetching: true, themes: []);

  @override
  Future<void> getThemes() async {
    sink.add(TaskCreationState(themes: [], isFetching: true, hasError: false, isSaved: false));

    final result = await _themeService.getThemes();

    if (result.valueOrNull != null) {
      sink.add(TaskCreationState(hasError: false, isFetching: false, isSaved: false, themes: result.value));
      _themes = result.value;
    } else {
      sink.add(TaskCreationState(hasError: true, isFetching: false, isSaved: false, themes: []));
    }
  }

  @override
  Future<void> submitTask(LabTask task) async {
    sink.add(TaskCreationState(themes: _themes, isFetching: true, hasError: false, isSaved: false));

    final result = await _taskService.createTask(task);

    if (result.valueOrNull != null) {
      sink.add(TaskCreationState(hasError: false, isFetching: false, isSaved: true, themes: _themes));
    } else {
      sink.add(TaskCreationState(hasError: true, isFetching: false, isSaved: false, themes: _themes));
    }
  }

  @override
  Future<void> submitTheme(String themeName) async {
    final theme = Theme(id: 0, name: themeName);
    final result = await _themeService.addTheme(theme);

    if (result.valueOrNull != null) {
      sink.add(TaskCreationState(
          hasError: false, isFetching: false, isSaved: false, themes: _themes, addThemeSuccess: true));
    } else {
      sink.add(TaskCreationState(
          hasError: false, isFetching: false, isSaved: false, themes: _themes, addThemeSuccess: false));
    }
  }

  @override
  Future<void> updateTask(LabTask task) async {
    sink.add(TaskCreationState(themes: _themes, isFetching: true, hasError: false, isSaved: false));

    final result = await _taskService.updateTask(task);

    if (result.valueOrNull != null) {
      sink.add(TaskCreationState(hasError: false, isFetching: false, isSaved: true, themes: _themes));
    } else {
      sink.add(TaskCreationState(hasError: true, isFetching: false, isSaved: false, themes: _themes));
    }
  }
}
