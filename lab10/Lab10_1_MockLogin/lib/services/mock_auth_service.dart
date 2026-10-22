class MockAuthException implements Exception {
  const MockAuthException(this.message);

  final String message;
}

class MockAuthService {
  Future<String> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (email.trim().toLowerCase() != 'student@example.com' ||
        password != '123456') {
      throw const MockAuthException('Email hoặc mật khẩu không đúng.');
    }

    return 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
  }
}
