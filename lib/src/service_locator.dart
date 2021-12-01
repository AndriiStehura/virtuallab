import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';
import 'package:virtuallab/src/core/repositories/task_repository.dart';
import 'package:virtuallab/src/core/services/auth_service.dart';

final serviceLocator = GetIt.instance;

void setup() {
  serviceLocator
    ..registerFactory<HttpClient>(() => HttpClient())
    ..registerFactory<DefaultIOClient>(() => DefaultIOClient(inner: serviceLocator()))
    ..registerFactory<JsonCodec>(() => const JsonCodec())
    ..registerFactory<AuthDataMapper>(() => const AuthDataMapper())
    ..registerFactory<LabTaskMapper>(() => const LabTaskMapper())
    ..registerFactory<AuthDataRepository>(
      () => AuthDataRepositoryImpl(
        serviceLocator(),
        mapper: serviceLocator(),
        codec: serviceLocator(),
      ),
    )
    ..registerFactory<AuthService>(
      () => AuthServiceImpl(authDataRepository: serviceLocator()),
    )
    ..registerFactory<TaskRepository>(() => TaskRepositoryImpl(
          serviceLocator(),
          mapper: serviceLocator(),
          codec: serviceLocator(),
        ));
}
