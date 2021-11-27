import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

class DefaultIOClient extends IOClient {
  DefaultIOClient({
    required HttpClient inner,
  }) : super(inner);

  @override
  Future<Response> get(
    final Uri url, {
    final Map<String, String>? headers,
  }) async {
    final result = await super.get(url, headers: headers);

    return result;
  }

  @override
  Future<Response> put(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await super.put(url, headers: headers);

    return result;
  }

  @override
  Future<Response> delete(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await super.delete(url, headers: headers);

    return result;
  }

  @override
  Future<Response> post(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await super.post(url, headers: headers);

    return result;
  }

  @override
  void close() {}
}
