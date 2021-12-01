import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/task/answer.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';

class AuthDataRepositoryMock extends Mock implements AuthDataRepository {}

class ClientMock extends Mock implements DefaultIOClient {}

class AuthDataMapperMock extends Mock implements AuthDataMapper {}

class JsonCodecMock extends Mock implements JsonCodec {}

class LabTaskMapperMock extends Mock implements LabTaskMapper {}

class AnswerMapperMock extends Mock implements AnswerMapper {}
