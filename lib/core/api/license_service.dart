import 'dart:convert';
import 'api_client.dart';

class LicenseService {
  static Future<Map<String, dynamic>> getLicense() async {
    final res = await ApiClient.get("license.php");

    if (res.statusCode != 200) {
      throw Exception("License API hatası (${res.statusCode})");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> checkLicense() async {
    final res = await ApiClient.get("license_status.php");

    if (res.statusCode != 200) {
      throw Exception("License status hatası (${res.statusCode})");
    }

    return jsonDecode(res.body);
  }
}
