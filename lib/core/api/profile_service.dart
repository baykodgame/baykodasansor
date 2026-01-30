import 'dart:convert';
import 'api_client.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await ApiClient.get("profile.php");
    return jsonDecode(res.body);
  }
}
