import 'package:flutter/foundation.dart';
import 'package:virtuallab/src/core/models/task/theme.dart';
import 'package:virtuallab/src/core/repositories/theme_repository.dart';
import 'package:virtuallab/src/core/result.dart';

abstract class ThemeService {
  Future<Result<List<Theme>, Exception>> getThemes();
  Future<Result<Theme, Exception>> getTheme(int id);
  Future<Result<bool, Exception>> addTheme(Theme theme);
  Future<Result<bool, Exception>> updateTheme(Theme theme);
  Future<Result<bool, Exception>> delete(int id);
}

class ThemeServiceImpl implements ThemeService {
  ThemeServiceImpl({required ThemeRepository repository}) : _repository = repository;

  final ThemeRepository _repository;

  @override
  Future<Result<List<Theme>, Exception>> getThemes() async {
    final result = await _repository.getThemes();

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<Theme, Exception>> getTheme(int id) async {
    final result = await _repository.getTheme(id);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> addTheme(Theme theme) async {
    final result = await _repository.addTheme(theme);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> updateTheme(Theme theme) async {
    final result = await _repository.updateTheme(theme);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }

  @override
  Future<Result<bool, Exception>> delete(int id) async {
    final result = await _repository.delete(id);

    if (result.exceptionOrNull != null) {
      debugPrint(result.exception.toString());
    }

    return result;
  }
}
