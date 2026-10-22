import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  String? _response;
  String? _token;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _authService.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _response = null;
      _token = null;
    });
    try {
      final response = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final token = _authService.parseToken(response.body);
        setState(() => _token = token);
        return;
      }
      setState(
        () => _response = 'HTTP ${response.statusCode}\n${response.body}',
      );
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() => _response = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _response = 'Không gửi được request. Kiểm tra kết nối mạng.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.2 · Real API Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Đăng nhập DummyJSON',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usernameController,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _login,
                    child: const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tài khoản mẫu: emilys / emilyspass',
                    textAlign: TextAlign.center,
                  ),
                  if (_response != null) ...[
                    const SizedBox(height: 24),
                    const Text('Phản hồi từ server:'),
                    const SizedBox(height: 8),
                    SelectableText(_response!),
                  ],
                  if (_token != null) ...[
                    const SizedBox(height: 24),
                    const Text('Đăng nhập thành công!'),
                    const SizedBox(height: 8),
                    const Text('Access token:'),
                    const SizedBox(height: 8),
                    SelectableText(_token!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
