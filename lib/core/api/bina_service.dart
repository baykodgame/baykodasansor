import 'dart:convert';
import 'api_client.dart';

class BinaService {
  static Future<Map<String, dynamic>> getBinalar() async {
    final res = await ApiClient.get("binalar.php");
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getBinaDetay(int id) async {
    final res = await ApiClient.get("bina_detay.php?id=$id");
    return jsonDecode(res.body);
  }

  static Future<void> binaEkle(Map<String, String> body) async {
    await ApiClient.post("bina_ekle.php", body);
  }

  static Future<void> binaGuncelle(Map<String, String> body) async {
    await ApiClient.post("bina_guncelle.php", body);
  }
}
