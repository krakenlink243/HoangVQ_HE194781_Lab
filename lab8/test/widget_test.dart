import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:lab8/main.dart';
import 'package:lab8/models/post.dart';
import 'package:lab8/services/api_service.dart';

// Fake server injected into ApiService – no real network in tests.
final _samplePosts = [
  {'userId': 1, 'id': 1, 'title': 'First post', 'body': 'Hello'},
  {'userId': 1, 'id': 2, 'title': 'Second post', 'body': 'World'},
];

MockClient _okClient() => MockClient((request) async {
  if (request.method == 'POST') {
    final body = json.decode(request.body) as Map<String, dynamic>;
    return http.Response(json.encode({...body, 'id': 101}), 201);
  }
  if (request.url.path == '/posts') {
    return http.Response(json.encode(_samplePosts), 200);
  }
  return http.Response('Not found', 404);
});

void main() {
  test('Post.fromJson maps all fields', () {
    final post = Post.fromJson(_samplePosts.first);
    expect(post.id, 1);
    expect(post.title, 'First post');
  });

  test('fetchPosts returns a List<Post>', () async {
    final posts = await ApiService(client: _okClient()).fetchPosts();
    expect(posts.length, 2);
  });

  test('fetchPosts throws a friendly ApiException on 404', () async {
    expect(
      ApiService(client: _okClient()).fetchPosts(simulateError: true),
      throwsA(isA<ApiException>()),
    );
  });

  test('createPost returns created post', () async {
    final post = await ApiService(client: _okClient())
        .createPost(title: 'T', body: 'B');
    expect(post.id, 101);
  });

  testWidgets('shows loading then the list', (tester) async {
    await tester.pumpWidget(MyApp(api: ApiService(client: _okClient())));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('First post'), findsOneWidget);
  });

  testWidgets('Simulate error menu switches list to error view', (tester) async {
    await tester.pumpWidget(MyApp(api: ApiService(client: _okClient())));
    await tester.pumpAndSettle();
    expect(find.text('First post'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulate error'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('First post'), findsNothing);
  });

  testWidgets('shows error view with Retry', (tester) async {
    final client = MockClient((_) async => http.Response('oops', 500));
    await tester.pumpWidget(MyApp(api: ApiService(client: client)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
