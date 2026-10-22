import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<http.Response> login(String username, String password) {
    return _client.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username.trim(), 'password': password}),
    );
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

  void dispose() => _client.close();
}
