import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.authService});

  final AuthService? authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _authService = widget.authService ?? AuthService();
  String? _error;
  bool _isLoading = false;
  String? _token;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _authService.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;
    setState(() {
      _error = null;
      _token = null;
    });
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _error = 'Vui lòng nhập username và mật khẩu.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
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
      setState(() => _error = _authService.errorMessage(response));
    } on TimeoutException {
      if (mounted) {
        setState(() => _error = 'Kết nối quá thời gian. Vui lòng thử lại.');
      }
    } on http.ClientException {
      if (mounted) {
        setState(
          () => _error = 'Không thể kết nối server. Kiểm tra kết nối mạng.',
        );
      }
    } on FormatException {
      if (mounted) {
        setState(
          () => _error = 'Phản hồi đăng nhập không hợp lệ. Vui lòng thử lại.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Đã xảy ra lỗi. Vui lòng thử lại.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                    enabled: !_isLoading,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tài khoản mẫu: emilys / emilyspass',
                    textAlign: TextAlign.center,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 24),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
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
