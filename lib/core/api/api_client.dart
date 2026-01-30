import 'dart:convert';
import 'package:http/http.dart' as http;
import '../security/secure_storage.dart';

class ApiClient {
  static const String baseUrl = "https://baykodasansor.com.tr/api/";
  static const Duration timeout = Duration(seconds: 20);

  static Future<Map<String, String>> _headers() async {
    final token = await SecureStorage.getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(String path) async {
    try {
      return await http
          .get(
            Uri.parse(baseUrl + path),
            headers: await _headers(),
          )
          .timeout(timeout);
    } catch (e) {
      throw Exception("GET isteği başarısız: $e");
    }
  }

  static Future<http.Response> post(String path, Map body) async {
    try {
      return await http
          .post(
            Uri.parse(baseUrl + path),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(timeout);
    } catch (e) {
      throw Exception("POST isteği başarısız: $e");
    }
  }
}
