import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/user/auth._data.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';
import 'package:virtuallab/src/core/result.dart';

import '../mocks.dart';

main() {
  late final AuthDataRepository repository;
  late final DefaultIOClient client;
  late final AuthDataMapper mapper;
  late final JsonCodec codec;

  const data = AuthData(email: 'email', passwordHash: 'password');
  setUp(() {
    registerFallbackValue(data);
    registerFallbackValue(Uri());

    mapper = AuthDataMapperMock();
    client = ClientMock();
    codec = JsonCodecMock();
    repository = AuthDataRepositoryImpl(client, mapper: mapper, codec: codec);
  });

  group('send uth data', () {
    setUp(() {
      when(() => mapper.toJson(any())).thenReturn('json');
      when(() => client.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => Response('body', 200));
    });

    test('success', () async {
      const expected = Result.success(true);

      final result = await repository.sendAuthData(data);

      expect(expected.value, result.value);
    });
  });
}
