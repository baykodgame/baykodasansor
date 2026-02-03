import 'dart:convert';
import 'package:http/http.dart' as http;
import '../security/secure_storage.dart';

class ApiClient {
  static const String baseUrl = "https://baykodasansor.com.tr/api/";
  static const Duration timeout = Duration(seconds: 20);

  /// Ortak header builder
  static Future<Map<String, String>> _headers() async {
    final token = await SecureStorage.getToken();

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  /// GET – Mevcut sistemle %100 uyumlu
  static Future<http.Response> get(String path) async {
    try {
      final uri = Uri.parse(baseUrl + path);

      final response = await http
          .get(
            uri,
            headers: await _headers(),
          )
          .timeout(timeout);

      return response;
    } catch (e) {
      // Mevcut davranış korunuyor
      throw Exception("GET isteği başarısız: $e");
    }
  }

  /// POST – Arıza / Bina / Login / FCM dahil hepsiyle uyumlu
  static Future<http.Response> post(String path, Map body) async {
    try {
      final uri = Uri.parse(baseUrl + path);

      final response = await http
          .post(
            uri,
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return response;
    } catch (e) {
      // Mevcut davranış korunuyor
      throw Exception("POST isteği başarısız: $e");
    }
  }
}
