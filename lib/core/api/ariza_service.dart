import 'dart:convert';
import 'api_client.dart';

class ArizaService {
  static Future<Map<String, dynamic>> getArizalar({int? binaId}) async {
    final path = binaId != null
        ? "arizalar.php?bina_id=$binaId"
        : "arizalar.php";

    final res = await ApiClient.get(path);
    return jsonDecode(res.body);
  }
}
