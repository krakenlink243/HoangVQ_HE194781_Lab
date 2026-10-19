// Lab 8 – Building an API-powered List Screen (Flutter + REST API)
//
// Structure:
//   models/post.dart              → Post model + fromJson()
//   services/api_service.dart     → ApiService (GET + POST, error handling)
//   screens/post_list_screen.dart → FutureBuilder + ListView.builder
//   screens/post_detail_screen.dart
//   screens/create_post_screen.dart (optional POST)

import 'package:flutter/material.dart';

import 'screens/post_list_screen.dart';
import 'services/api_service.dart';

void main() => runApp(MyApp(api: ApiService()));

class MyApp extends StatelessWidget {
  final ApiService api;
  const MyApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 – Posts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PostListScreen(api: api),
    );
  }
}
