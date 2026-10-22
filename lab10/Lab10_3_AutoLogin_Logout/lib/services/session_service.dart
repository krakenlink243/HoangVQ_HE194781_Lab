import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    return token == null || token.trim().isEmpty ? null : token;
  }

  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString('token', token);
    if (!saved) {
      throw StateError('Không thể lưu phiên đăng nhập.');
    }
  }

  Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    final removed = await preferences.remove('token');
    if (!removed) {
      throw StateError('Không thể xoá phiên đăng nhập.');
    }
  }
}
