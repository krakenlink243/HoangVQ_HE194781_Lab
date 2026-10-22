import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab10_2_real_api_login/screens/login_screen.dart';
import 'package:lab10_2_real_api_login/services/auth_service.dart';

void main() {
  Future<void> enterCredentials(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'emilys');
    await tester.enterText(find.byType(TextField).at(1), 'emilyspass');
  }

  testWidgets('Loading prevents duplicate requests and failure allows retry', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    var requests = 0;
    final service = AuthService(
      client: MockClient((_) {
        requests++;
        if (requests == 1) return pending.future;
        return Future.value(http.Response('{"accessToken":"test-token"}', 200));
      }),
    );
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authService: service)),
    );
    await enterCredentials(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.enabled, isFalse);
    }
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(requests, 1);

    pending.complete(http.Response('{"message":"Invalid credentials"}', 400));
    await tester.pumpAndSettle();
    expect(find.text('Username hoặc mật khẩu không đúng.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Username hoặc mật khẩu không đúng.'), findsNothing);
    expect(find.text('Đăng nhập thành công!'), findsOneWidget);
    expect(find.text('test-token'), findsOneWidget);
  });

  final cases = <String, Future<http.Response> Function()>{
    'Không thể kết nối server. Kiểm tra kết nối mạng.': () async =>
        throw http.ClientException('offline'),
    'Kết nối quá thời gian. Vui lòng thử lại.': () async =>
        throw TimeoutException('timeout'),
    'Phản hồi đăng nhập không hợp lệ. Vui lòng thử lại.': () async =>
        http.Response('{}', 200),
    'Server đang gặp sự cố. Vui lòng thử lại sau.': () async =>
        http.Response('unavailable', 503),
  };

  for (final entry in cases.entries) {
    testWidgets('Restores form after ${entry.key}', (tester) async {
      final service = AuthService(client: MockClient((_) => entry.value()));
      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(authService: service)),
      );
      await enterCredentials(tester);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.text(entry.key), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      expect(find.text('Access token:'), findsNothing);
    });
  }
}
