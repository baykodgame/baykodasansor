import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'user_role.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _tokenKey = "token";
  static const _roleKey = "user_role";

  // 🔑 TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  // 👤 ROLE
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  static Future<UserRole> getRole() async {
    final roleStr = await _storage.read(key: _roleKey);
    return parseRole(roleStr);
  }

  // 🚪 LOGOUT / TEMİZLEME
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
