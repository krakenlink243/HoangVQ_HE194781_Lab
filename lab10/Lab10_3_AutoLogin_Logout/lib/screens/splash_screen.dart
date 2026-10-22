import 'dart:async';

import 'package:flutter/material.dart';

import '../services/session_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), _restoreSession);
  }

  Future<void> _restoreSession() async {
    String? token;
    try {
      token = await _sessionService.getToken();
    } catch (_) {
      token = null;
    }
    if (!mounted) return;
    final screen = token == null
        ? const LoginScreen()
        : HomeScreen(token: token);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Lab 10.3',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Auto Login & Logout'),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
