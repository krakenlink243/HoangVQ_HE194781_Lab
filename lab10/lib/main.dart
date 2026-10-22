import 'package:flutter/material.dart';
import 'package:lab10_1_mock_login/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockLoginApp();
  }
}
