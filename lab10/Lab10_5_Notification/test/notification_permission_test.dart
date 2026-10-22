import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/main.dart';

void main() {
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AndroidFlutterLocalNotificationsPlugin.registerWith();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  for (final granted in [true, false]) {
    testWidgets('Permission request displays result: $granted', (tester) async {
      final permission = Completer<bool>();
      var requests = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'initialize') return true;
            if (call.method == 'requestNotificationsPermission') {
              requests++;
              return permission.future;
            }
            return null;
          });
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();
      expect(requests, 0);

      await tester.tap(find.text('Xin quyền thông báo'));
      await tester.pump();
      expect(requests, 1);
      expect(find.text('Đang xin quyền...'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton).first).onPressed,
        isNull,
      );

      permission.complete(granted);
      await tester.pumpAndSettle();
      expect(
        find.text(
          granted ? 'Đã được cấp quyền thông báo.' : 'Chưa được cấp quyền thông báo. Bạn có thể bật quyền trong Cài đặt ứng dụng.',
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton).first).onPressed,
        isNotNull,
      );
    });
  }

  testWidgets('A permission request error allows retry', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'initialize') return true;
          if (call.method == 'requestNotificationsPermission') {
            throw PlatformException(code: 'request_failed');
          }
          return null;
        });
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xin quyền thông báo'));
    await tester.pumpAndSettle();
    expect(
      find.text('Không thể xin quyền thông báo. Vui lòng thử lại.'),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton).first).onPressed,
      isNotNull,
    );
  });
}
