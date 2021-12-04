import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/extensions/map.dart';

abstract class Repository implements Disposable {}

class RequestRepository implements Repository {
  String get apiPath => 'localhost:44366';

  Map<String, String> get defaultHeaders => {'Content-Type': 'application/json', 'Accept': 'application/json'};

  @override
  FutureOr onDispose() {}

  Uri requestUri(
    final ApiRequest request, {
    final Map<String, String>? parameters,
    final Map<String, dynamic>? queryParameters,
  }) {
    final path = parameters.isBlank ? _getPath(request) : _getPathWithParameters(request, parameters);

    return Uri.https(apiPath, path).replace(queryParameters: queryParameters);
  }

  String _getPath(ApiRequest request) {
    switch (request) {
      default:
        return apiPath + request.name;
    }
  }

  String _getPathWithParameters(ApiRequest request, final Map<String, String>? parameters) {
    switch (request) {
      default:
        return '';
    }
  }
}
