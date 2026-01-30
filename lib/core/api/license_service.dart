import 'dart:convert';
import 'api_client.dart';

class LicenseService {
  static Future<Map<String, dynamic>> getLicense() async {
    final res = await ApiClient.get("license.php");
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> checkLicense() async {
    final res = await ApiClient.get("license_status.php");
    return jsonDecode(res.body);
  }
}
