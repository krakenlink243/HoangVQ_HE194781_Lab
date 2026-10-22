import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<http.Response> login(String username, String password) {
    return _client
        .post(
          Uri.parse('https://dummyjson.com/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username.trim(), 'password': password}),
        )
        .timeout(const Duration(seconds: 15));
  }

  String parseToken(String responseBody) {
    final data = jsonDecode(responseBody);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Phản hồi đăng nhập không hợp lệ.');
    }
    final token = data['accessToken'];
    if (token is! String || token.trim().isEmpty) {
      throw const FormatException('Phản hồi không chứa accessToken hợp lệ.');
    }
    return token;
  }

  String errorMessage(http.Response response) {
    if (response.statusCode == 400 || response.statusCode == 401) {
      return 'Username hoặc mật khẩu không đúng.';
    }
    if (response.statusCode == 429) {
      return 'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau.';
    }
    if (response.statusCode >= 500) {
      return 'Server đang gặp sự cố. Vui lòng thử lại sau.';
    }
    return 'Đăng nhập thất bại (HTTP ${response.statusCode}). Vui lòng thử lại.';
  }

  void dispose() => _client.close();
}
