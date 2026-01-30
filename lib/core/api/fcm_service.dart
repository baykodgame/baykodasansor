import './api_client.dart';

class FcmService {
  static Future<void> saveFcmToken(String token) async {
    await ApiClient.post(
      "save_fcm_token.php",
      {
        "fcm_token": token,
      },
    );
  }
}
