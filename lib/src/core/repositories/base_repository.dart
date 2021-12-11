import 'dart:async';

import 'package:virtuallab/src/core/api_request.dart';
import 'package:virtuallab/src/core/extensions/map.dart';

abstract class Repository {}

class RequestRepository implements Repository {
  String get apiPath => 'localhost:44366';

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
        return '/Api' + request.name;
    }
  }

  String _getPathWithParameters(ApiRequest request, final Map<String, String>? parameters) {
    return '/Api' + request.name + (parameters?.values.map((e) => '/$e').join() ?? '');
  }
}
