import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/user/auth._data.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';

class AuthDataRepositoryMock extends Mock implements AuthDataRepository {}

class ClientMock extends Mock implements DefaultIOClient {}

class AuthDataMapperMock extends Mock implements AuthDataMapper {}

class JsonCodecMock extends Mock implements JsonCodec {}
