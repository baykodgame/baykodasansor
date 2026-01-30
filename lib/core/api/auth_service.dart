import 'dart:convert';
import '../models/login_models.dart';
import '../security/secure_storage.dart';
import 'api_client.dart';

class AuthService {
  static Future<LoginResponse> login(
    String username,
    String password,
  ) async {
    try {
      final response = await ApiClient.post(
        "login.php",
        {
          "username": username,
          "password": password,
        },
      );

      // 🔒 Boş body (PHP fatal error / echo yok durumu)
      if (response.body.isEmpty) {
        return LoginResponse(
          status: false,
          message: "Sunucudan yanıt alınamadı",
        );
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      // ❌ Login başarısız
      if (response.statusCode != 200 || data["status"] != true) {
        return LoginResponse(
          status: false,
          message: data["message"] ?? "Kullanıcı adı veya şifre hatalı",
        );
      }

      // ✅ Token
      final String token = data["data"]["token"];
      await SecureStorage.saveToken(token);

      // ✅ Role (ileride drawer / yetki için)
      final String role = data["data"]["user"]["role"];
      await SecureStorage.saveRole(role);

      return LoginResponse.fromJson(data);
    } catch (e) {
      // 🌐 Network / JSON / timeout / SSL
      return LoginResponse(
        status: false,
        message: "Bağlantı hatası. İnternetinizi kontrol edin.",
      );
    }
  }
}
