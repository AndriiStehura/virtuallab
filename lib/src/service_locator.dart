import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:virtuallab/src/bloc/auth_bloc.dart';
import 'package:virtuallab/src/bloc/profile_bloc.dart';
import 'package:virtuallab/src/bloc/statistics_bloc.dart';
import 'package:virtuallab/src/bloc/task_creation_bloc.dart';
import 'package:virtuallab/src/bloc/task_passing_bloc.dart';
import 'package:virtuallab/src/bloc/task_select_bloc.dart';
import 'package:virtuallab/src/core/default_io_client.dart';
import 'package:virtuallab/src/core/models/task/answer.dart';
import 'package:virtuallab/src/core/models/task/lab_task.dart';
import 'package:virtuallab/src/core/models/task/task_statistics.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/models/user/auth_data.dart';
import 'package:virtuallab/src/core/models/user/identity.dart';
import 'package:virtuallab/src/core/models/user/user.dart';
import 'package:virtuallab/src/core/repositories/auth_data_repository.dart';
import 'package:virtuallab/src/core/repositories/statistics_repository.dart';
import 'package:virtuallab/src/core/repositories/task_repository.dart';
import 'package:virtuallab/src/core/repositories/theme_repository.dart';
import 'package:virtuallab/src/core/repositories/user_repository.dart';
import 'package:virtuallab/src/core/services/auth_service.dart';
import 'package:virtuallab/src/core/services/statistics_service.dart';
import 'package:virtuallab/src/core/services/task_service.dart';
import 'package:virtuallab/src/core/services/theme_service.dart';

import 'core/services/user_service.dart';

final serviceLocator = GetIt.instance;

void setup() {
  serviceLocator
    ..registerFactory<DefaultIOClient>(() => DefaultIOClient())
    ..registerFactory<JsonCodec>(() => const JsonCodec())
    ..registerFactory<AuthDataMapper>(() => const AuthDataMapper())
    ..registerFactory<LabTaskMapper>(() => const LabTaskMapper())
    ..registerFactory<AnswerMapper>(() => const AnswerMapper())
    ..registerFactory<TaskStatisticsMapper>(() => const TaskStatisticsMapper())
    ..registerFactory<UserMapper>(() => const UserMapper())
    ..registerFactory<ThemeMapper>(() => const ThemeMapper())
    ..registerFactory<IdentityMapper>(() => IdentityMapper())
    ..registerFactory<StatisticsRepository>(() => StatisticsRepositoryImpl(
          serviceLocator(),
        ))
    ..registerFactory<TaskRepository>(() => TaskRepositoryImpl(
          serviceLocator(),
          mapper: serviceLocator(),
          codec: serviceLocator(),
        ))
    ..registerFactory<AuthDataRepository>(() => AuthDataRepositoryImpl(
          serviceLocator(),
          mapper: serviceLocator(),
          userMapper: serviceLocator(),
          codec: serviceLocator(),
        ))
    ..registerFactory<ThemeRepository>(() => ThemeRepositoryImpl(
          serviceLocator(),
          mapper: serviceLocator(),
          codec: serviceLocator(),
        ))
    ..registerFactory<UserRepository>(() => UserRepositoryImpl(
          serviceLocator(),
          mapper: serviceLocator(),
          codec: serviceLocator(),
        ))
    ..registerSingleton<AuthService>(
      AuthServiceImpl(authDataRepository: serviceLocator()),
    )
    ..registerFactory<StatisticsService>(
      () => StatisticsServiceImpl(repository: serviceLocator()),
    )
    ..registerFactory<TaskService>(
      () => TaskServiceImpl(repository: serviceLocator()),
    )
    ..registerFactory<ThemeService>(
      () => ThemeServiceImpl(repository: serviceLocator()),
    )
    ..registerFactory<UserService>(
      () => UserServiceImpl(repository: serviceLocator()),
    )
    ..registerFactory<SignUpBloc>(
      () => SignUpBlocImpl(authService: serviceLocator()),
    )
    ..registerFactory<TaskSelectBloc>(
      () => TaskSelectBlocImpl(themeService: serviceLocator(), taskService: serviceLocator()),
    )
    ..registerFactory<ProfileBloc>(
      () => ProfileBlocImpl(authService: serviceLocator(), userService: serviceLocator()),
    )
    ..registerFactory<StatisticsBloc>(
      () => StatisticsBlocImpl(authService: serviceLocator(), statisticsService: serviceLocator()),
    )
    ..registerFactory<TaskPassingBloc>(
      () => TaskPassingBlocImpl(authService: serviceLocator(), taskService: serviceLocator()),
    )
    ..registerFactory<TaskCreationBloc>(
      () => TaskCreationBlocImpl(themeService: serviceLocator(), taskService: serviceLocator()),
    );
}
