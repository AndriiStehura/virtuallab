import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/task/answer.dart';
import 'package:virtuallab/src/core/models/task/compexity.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/repositories/task_repository.dart';
import 'package:virtuallab/src/core/result.dart';

import '../mocks.dart';

main() {
  late final TaskRepository repository;
  late final LabTaskMapper mapper;
  late final AnswerMapper answerMapper;
  late final JsonCodec codec;
  late final DefaultIOClient client;

  final theme = Theme(id: 1, name: 'name');
  final task = LabTask(
    id: 1,
    description: 'description',
    answer: 'answer',
    complexity: Complexity.hard,
    themeId: 1,
    theme: theme,
  );

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(task);

    client = ClientMock();
    mapper = LabTaskMapperMock();
    answerMapper = AnswerMapperMock();
    codec = JsonCodecMock();
    repository = TaskRepositoryImpl(client, mapper: mapper, answerMapper: answerMapper, codec: codec);
  });

  group('get task', () {
    setUpAll(() {
      when(() => client.get(any())).thenAnswer((_) async => Response('"success" : true', HttpStatus.ok));
      when(() => mapper.fromJson(any())).thenAnswer((_) => task);
    });

    test('success', () async {
      final expected = task;

      final result = await repository.getTask(0);

      expect(result.value, expected);
    });

    test('failed', () async {
      const id = 1;
      const exception = 'Get task failed id : $id';
      final expected = Result.failed(Exception(exception));
      when(() => client.get(any())).thenAnswer((_) async => Response('body', 401));

      final result = await repository.getTask(id);

      expect(expected.exception.toString(), result.exception.toString());
    });
  });

  group('create task', () {
    setUpAll(() {
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => Response('"success" : true', HttpStatus.ok));
      when(() => mapper.toJson(any())).thenAnswer((_) => "json");
    });

    test('success', () async {
      const expected = true;

      final result = await repository.createTask(task);

      expect(result.value, expected);
    });

    test('failed', () async {
      const exception = 'Create task failed';
      final expected = Result.failed(Exception(exception));
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => Response('body', 401));

      final result = await repository.createTask(task);

      expect(expected.exception.toString(), result.exception.toString());
    });
  });

  // test('dispose success', () {
  //   repository.onDispose();

  //   verify(() => client.close());
  // });
}
