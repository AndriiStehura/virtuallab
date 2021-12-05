import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class DefaultIOClient {
  DefaultIOClient();
  Map<String, String> get defaultHeaders => {'Content-Type': 'application/json', 'Accept': 'application/json'};

  @override
  Future<http.Response> get(
    final Uri url, {
    final Map<String, String>? headers,
  }) async {
    final result = await http.get(url, headers: headers);

    return result;
  }

  @override
  Future<http.Response> put(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await http.put(url, headers: headers);

    return result;
  }

  @override
  Future<http.Response> delete(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await http.delete(url, headers: headers);

    return result;
  }

  @override
  Future<http.Response> post(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await http.post(url, headers: headers ?? defaultHeaders, body: body, encoding: encoding);

    return result;
  }

  @override
  void close() {}
}
