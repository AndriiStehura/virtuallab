import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';
import 'package:virtuallab/src/core/result.dart';

import '../mocks.dart';

main() {
  late final AuthDataRepository repository;
  late final DefaultIOClient client;
  late final AuthDataMapper mapper;
  late final JsonCodec codec;

  const data = AuthData(email: 'email', passwordHash: 'password');
  setUpAll(() {
    registerFallbackValue(data);
    registerFallbackValue(Uri());

    mapper = AuthDataMapperMock();
    client = ClientMock();
    codec = JsonCodecMock();
    repository = AuthDataRepositoryImpl(client, mapper: mapper, codec: codec);
  });

  group('login', () {
    setUp(() {
      when(() => mapper.toJson(any())).thenReturn('json');
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer((_) async => Response('body', 200));
    });

    test('success', () async {
      const expected = Result.success(true);

      final result = await repository.auth(data);

      expect(expected.value, result.value);
    });

    test('failed with http exception', () async {
      const exception = 'Send user data failed';
      final expected = Result.failed(Exception(exception));
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer((_) async => Response('body', 500));

      final result = await repository.auth(data);

      expect(expected.exception.toString(), result.exception.toString());
    });
  });

  group('register', () {
    setUp(() {
      when(() => mapper.toJson(any())).thenReturn('json');
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer((_) async => Response('body', 200));
    });

    test('success', () async {
      const expected = Result.success(true);

      final result = await repository.register(data);

      expect(expected.value, result.value);
    });

    test('failed with http exception', () async {
      const exception = 'Register failed';
      final expected = Result.failed(Exception(exception));
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer((_) async => Response('body', 500));

      final result = await repository.register(data);

      expect(expected.exception.toString(), result.exception.toString());
    });
  });

  group('signout', () {
    setUp(() {
      when(() => mapper.toJson(any())).thenReturn('json');
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer((_) async => Response('body', 200));
    });

    test('success', () async {
      const expected = Result.success(true);

      final result = await repository.signOut(data);

      expect(expected.value, result.value);
    });

    test('failed with http exception', () async {
      const exception = 'SignOut failed';
      final expected = Result.failed(Exception(exception));
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer((_) async => Response('body', 500));

      final result = await repository.signOut(data);

      expect(expected.exception.toString(), result.exception.toString());
    });
  });

  test('dispose success', () {
    repository.onDispose();

    verify(() => client.close());
  });
}
