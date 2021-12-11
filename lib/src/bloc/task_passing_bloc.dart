import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';
import 'package:virtuallab/src/core/models/task/answer.dart';
import 'package:virtuallab/src/core/models/task/grade.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/services/auth_service.dart';
import 'package:virtuallab/src/core/services/task_service.dart';

class TaskPassingState {
  bool isSubmitted;
  bool hasError;
  bool isWaiting;
  TaskPassingState({
    required this.isSubmitted,
    required this.hasError,
    required this.isWaiting,
  });

  TaskPassingState copyWith({
    bool? isSubmitted,
    bool? hasError,
    bool? isWaiting,
  }) {
    return TaskPassingState(
      isSubmitted: isSubmitted ?? this.isSubmitted,
      hasError: hasError ?? this.hasError,
      isWaiting: isWaiting ?? this.isWaiting,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isSubmitted': isSubmitted,
      'hasError': hasError,
      'isWaiting': isWaiting,
    };
  }

  factory TaskPassingState.fromMap(Map<String, dynamic> map) {
    return TaskPassingState(
      isSubmitted: map['isSubmitted'],
      hasError: map['hasError'],
      isWaiting: map['isWaiting'],
    );
  }

  @override
  String toString() => 'TaskPassingState(isSubmitted: $isSubmitted, hasError: $hasError, isWaiting: $isWaiting)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskPassingState &&
        other.isSubmitted == isSubmitted &&
        other.hasError == hasError &&
        other.isWaiting == isWaiting;
  }

  @override
  int get hashCode => isSubmitted.hashCode ^ hasError.hashCode ^ isWaiting.hashCode;
}

abstract class TaskPassingBloc {
  ValueStream<TaskPassingState> get state;
  TaskPassingState get initial;

  Future<Grade?> submitTask(LabTask task, String answer);
}

class TaskPassingBlocImpl implements TaskPassingBloc {
  TaskPassingBlocImpl({required TaskService taskService, required AuthService authService})
      : _taskService = taskService,
        _authService = authService;

  final TaskService _taskService;
  final AuthService _authService;

  @override
  ValueStream<TaskPassingState> get state => _subject.stream;

  StreamSink<TaskPassingState> get sink => _subject.sink;

  final BehaviorSubject<TaskPassingState> _subject = BehaviorSubject<TaskPassingState>();

  @override
  TaskPassingState get initial => TaskPassingState(hasError: false, isSubmitted: false, isWaiting: false);

  @override
  Future<Grade?> submitTask(LabTask task, String answer) async {
    sink.add(TaskPassingState(isWaiting: true, hasError: false, isSubmitted: false));

    final userAnswer = Answer(answer: answer, taskId: task.id, userId: _authService.currentUser!.id);
    final result = await _taskService.checkAnswer(userAnswer);

    if (result.valueOrNull != null) {
      sink.add(TaskPassingState(isSubmitted: true, hasError: false, isWaiting: false));
    } else {
      sink.add(TaskPassingState(isSubmitted: false, hasError: true, isWaiting: false));
    }
    return result.valueOrNull;
  }
}
