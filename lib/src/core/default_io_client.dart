import 'dart:convert';
import 'package:http/http.dart' as http;

class DefaultIOClient {
  DefaultIOClient();
  Map<String, String> get defaultHeaders => {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Future<http.Response> get(
    final Uri url, {
    final Map<String, String>? headers,
  }) async {
    final result = await http.get(url, headers: headers);

    return result;
  }

  Future<http.Response> put(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await http.put(url, body: body, headers: headers ?? defaultHeaders);

    return result;
  }

  Future<http.Response> delete(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await http.delete(url, headers: headers);

    return result;
  }

  Future<http.Response> post(
    final Uri url, {
    final Map<String, String>? headers,
    final dynamic body,
    final Encoding? encoding,
  }) async {
    final result = await http.post(url, headers: headers ?? defaultHeaders, body: body, encoding: encoding);

    return result;
  }

  void close() {}
}
