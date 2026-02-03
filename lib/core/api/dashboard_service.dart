import 'dart:convert';
import 'api_client.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getDashboard() async {
    final binalar = await ApiClient.get("binalar.php");
    final arizalar = await ApiClient.get("arizalar.php");
    final bakimlar = await ApiClient.get("bakimlar.php");
    final periyodik = await ApiClient.get("periyodik.php");

    return {
      "binalar": jsonDecode(binalar.body),
      "arizalar": jsonDecode(arizalar.body),
      "bakimlar": jsonDecode(bakimlar.body),
      "periyodik": jsonDecode(periyodik.body),
    };
  }
}
