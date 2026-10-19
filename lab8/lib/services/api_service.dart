import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';

/// Error with a user-friendly message, thrown by [ApiService].
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Service layer: all networking lives here, the UI only renders (Lab 8.4).
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration timeout = Duration(seconds: 10);

  /// Injected so tests can pass a MockClient instead of the real network.
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// GET /posts → `List<Post>` (Lab 8.1 + 8.2)
  Future<List<Post>> fetchPosts({bool simulateError = false}) async {
    // A wrong path returns 404 – handy for screenshotting the error state.
    final path = simulateError ? '/invalid-endpoint' : '/posts';
    final response = await _send(() => client.get(Uri.parse('$baseUrl$path')));
    // Lab 8.1: print raw JSON for verification (first 200 chars).
    final preview = response.body.length > 200
        ? response.body.substring(0, 200)
        : response.body;
    debugPrint('GET $path → ${response.statusCode}: $preview');

    if (response.statusCode != 200) {
      throw ApiException(
        'Something went wrong (HTTP ${response.statusCode}). Please try again.',
      );
    }

    try {
      // json.decode turns the raw String into a List<dynamic> of Maps.
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ApiException('Received unexpected data from the server.');
    }
  }

  /// POST /posts → the created Post (Optional step)
  Future<Post> createPost({required String title, required String body}) async {
    final response = await _send(
      () => client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'userId': 1, 'title': title, 'body': body}),
      ),
    );

    if (response.statusCode != 201) {
      throw ApiException(
        'Could not create the post (HTTP ${response.statusCode}).',
      );
    }
    return Post.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  /// Runs a request with a timeout and converts low-level errors
  /// into friendly [ApiException]s (Lab 8.3).
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException {
      throw const ApiException('The server took too long to respond.');
    } on http.ClientException {
      throw const ApiException(
        'No internet connection. Please check your network.',
      );
    }
  }

  void dispose() => client.close();
}
