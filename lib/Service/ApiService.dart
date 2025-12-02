import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class ApiService {
  final String baseUrl = 'https://10.0.2.2:7156/api/';
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _cookie;
  late final HttpClient _httpClient;
  late final IOClient _client;


  void init() {
    _httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    _client = IOClient(_httpClient);
  }


  void dispose() {
    _client.close();
  }


  void _updateCookie(HttpClientResponse response) {
    final setCookie = response.headers.value('set-cookie');
    if (setCookie != null) {
      _cookie = setCookie.split(';').first;
      print("🍪 Cookie updated: $_cookie");
    }
  }


  // ---------------- Helper chung ----------------
  Future<dynamic> _handleResponse(HttpClientResponse response) async {
    final body = await response.transform(utf8.decoder).join();
    print("🔹 Status: ${response.statusCode}");

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return body.isEmpty ? null : jsonDecode(body);
    } else {
      print("HTTP Error: ${response.statusCode} - $body");
      throw HttpException('Error ${response.statusCode}: $body');
    }
  }

  Future<List<dynamic>> getJsonList(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print("🔹 GET List: $uri");

    final request = await _httpClient.getUrl(uri);
    if (_cookie != null) request.headers.set('Cookie', _cookie!);
    final response = await request.close();
    _updateCookie(response);

    final data = await _handleResponse(response);
    return data is List ? data : [data];
  }

  Future<dynamic> getJson(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print("🔹 GET: $uri");

    final request = await _httpClient.getUrl(uri);
    if (_cookie != null) request.headers.set('Cookie', _cookie!);
    final response = await request.close();
    _updateCookie(response);

    return _handleResponse(response);
  }

  // ---------------- POST ----------------
  Future<Map<String, dynamic>?> postJson(
      String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print("🔹 POST: $uri");
    print("📦 Body: $body");

    final request = await _httpClient.postUrl(uri);
    request.headers.contentType = ContentType.json;
    if (_cookie != null) request.headers.set('Cookie', _cookie!);

    request.add(utf8.encode(jsonEncode(body)));
    final response = await request.close();
    _updateCookie(response);

    final data = await _handleResponse(response);
    return data == null ? null : Map<String, dynamic>.from(data);
  }

  // ---------------- DELETE ----------------
  Future<bool> deleteJson(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print("🗑️ DELETE: $uri");

    final request = await _httpClient.deleteUrl(uri);
    if (_cookie != null) request.headers.set('Cookie', _cookie!);
    final response = await request.close();
    _updateCookie(response);

    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      print("✅ Xóa thành công: $endpoint");
      return true;
    } else {
      print("❌ Xóa thất bại: ${response.statusCode} - $body");
      return false;
    }
  }

  // ---------------- PUT (nếu cần) ----------------
  Future<Map<String, dynamic>?> putJson(
      String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print("🔹 PUT: $uri");
    print("📦 Body: $body");

    final request = await _httpClient.putUrl(uri);
    request.headers.contentType = ContentType.json;
    if (_cookie != null) request.headers.set('Cookie', _cookie!);

    request.add(utf8.encode(jsonEncode(body)));
    final response = await request.close();
    _updateCookie(response);

    final data = await _handleResponse(response);
    return data == null ? null : Map<String, dynamic>.from(data);
  }

}
