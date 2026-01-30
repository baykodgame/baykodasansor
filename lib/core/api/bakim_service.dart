import 'dart:convert';
import './api_client.dart';

class BakimService {
  static Future<Map<String, dynamic>> getBakimlar() async {
    final res = await ApiClient.get("bakimlar.php");
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getPeriyodik() async {
    final res = await ApiClient.get("periyodik.php");
    return jsonDecode(res.body);
  }
}
