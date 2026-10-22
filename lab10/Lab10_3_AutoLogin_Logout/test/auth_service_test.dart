import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab10_3_auto_login_logout/services/auth_service.dart';

void main() {
  test('Login posts JSON credentials and returns the raw response', () async {
    final service = AuthService(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), 'https://dummyjson.com/auth/login');
        expect(request.headers['Content-Type'], 'application/json');
        expect(jsonDecode(request.body), {
          'username': 'emilys',
          'password': 'emilyspass',
        });
        return http.Response('{"accessToken":"test-token"}', 200);
      }),
    );
    addTearDown(service.dispose);
    final response = await service.login(' emilys ', 'emilyspass');
    expect(response.statusCode, 200);
    expect(response.body, '{"accessToken":"test-token"}');
    expect(service.parseToken(response.body), 'test-token');
  });

  test('Login preserves a rejected response', () async {
    final service = AuthService(
      client: MockClient((_) async {
        return http.Response('{"message":"Invalid credentials"}', 400);
      }),
    );
    addTearDown(service.dispose);
    final response = await service.login('emilys', 'wrongpassword');
    expect(response.statusCode, 400);
    expect(response.body, '{"message":"Invalid credentials"}');
  });

  test('Token parsing rejects malformed JSON and invalid tokens', () {
    final service = AuthService();
    addTearDown(service.dispose);

    for (final body in [
      'invalid-json',
      '[]',
      'null',
      '{}',
      '{"accessToken":null}',
      '{"accessToken":123}',
      '{"accessToken":""}',
      '{"accessToken":"   "}',
    ]) {
      expect(() => service.parseToken(body), throwsFormatException);
    }
  });
}
