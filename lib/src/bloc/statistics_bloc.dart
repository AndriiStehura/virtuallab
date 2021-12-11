import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';
import 'package:virtuallab/src/core/models/task/task_statistics.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/services/auth_service.dart';
import 'package:virtuallab/src/core/services/statistics_service.dart';

class StatisticsState {
  final bool isFetching;

  final bool hasError;

  final List<TaskStatistics>? stats;

  StatisticsState({
    required this.isFetching,
    required this.hasError,
    this.stats,
  });

  StatisticsState copyWith({
    bool? isFetching,
    bool? hasError,
    List<TaskStatistics>? stats,
  }) {
    return StatisticsState(
      isFetching: isFetching ?? this.isFetching,
      hasError: hasError ?? this.hasError,
      stats: stats ?? this.stats,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is StatisticsState &&
        other.isFetching == isFetching &&
        other.hasError == hasError &&
        listEquals(other.stats, stats);
  }

  @override
  int get hashCode => isFetching.hashCode ^ hasError.hashCode ^ stats.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'isFetching': isFetching,
      'hasError': hasError,
      'stats': stats?.map((x) => x.toMap()).toList(),
    };
  }

  factory StatisticsState.fromMap(Map<String, dynamic> map) {
    return StatisticsState(
      isFetching: map['isFetching'],
      hasError: map['hasError'],
      stats:
          map['stats'] != null ? List<TaskStatistics>.from(map['stats']?.map((x) => TaskStatistics.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticsState.fromJson(String source) => StatisticsState.fromMap(json.decode(source));

  @override
  String toString() => 'StatisticsState(isFetching: $isFetching, hasError: $hasError, stats: $stats)';
}

abstract class StatisticsBloc {
  ValueStream<StatisticsState> get state;
  StatisticsState get initial;

  Future<void> fetchStatistics();
}

class StatisticsBlocImpl implements StatisticsBloc {
  StatisticsBlocImpl({required AuthService authService, required StatisticsService statisticsService})
      : _authService = authService,
        _statisticsService = statisticsService;

  final AuthService _authService;
  final StatisticsService _statisticsService;

  @override
  ValueStream<StatisticsState> get state => _subject.stream;

  StreamSink<StatisticsState> get sink => _subject.sink;

  final BehaviorSubject<StatisticsState> _subject = BehaviorSubject<StatisticsState>();

  @override
  StatisticsState get initial => StatisticsState(
        isFetching: false,
        hasError: false,
      );

  @override
  Future<void> fetchStatistics() async {
    sink.add(StatisticsState(isFetching: true, stats: null, hasError: false));

    final user = _authService.currentUser!;

    final result = await _statisticsService.getStatistics(user.id);
    if (result.value != null) {
      sink.add(StatisticsState(isFetching: false, hasError: false, stats: result.valueOrNull));
    } else {
      sink.add(StatisticsState(isFetching: false, hasError: true));
    }
  }
}
