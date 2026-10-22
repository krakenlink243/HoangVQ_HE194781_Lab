import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');

  setUp(() => AndroidFlutterLocalNotificationsPlugin.registerWith());
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  for (final result in ['success', 'revoked', 'error']) {
    testWidgets('Demo notification handles $result', (tester) async {
      final pending = Completer<void>();
      final shown = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            if (call.method == 'initialize' ||
                call.method == 'requestNotificationsPermission') {
              return true;
            }
            if (call.method == 'areNotificationsEnabled') {
              return result != 'revoked';
            }
            if (call.method == 'show') {
              shown.add(call);
              if (result == 'error') {
                throw PlatformException(code: 'send_failed');
              }
              await pending.future;
            }
            return null;
          });
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();
      final sendButton = find.widgetWithText(
        FilledButton,
        'Gửi thông báo demo',
      );
      expect(tester.widget<FilledButton>(sendButton).onPressed, isNull);
      expect(shown, isEmpty);
      await tester.tap(find.text('Xin quyền thông báo'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(sendButton).onPressed, isNotNull);
      await tester.tap(sendButton);
      await tester.pump();

      if (result == 'success') {
        expect(find.text('Đang gửi...'), findsOneWidget);
        for (final button in tester.widgetList<FilledButton>(
          find.byType(FilledButton),
        )) {
          expect(button.onPressed, isNull);
        }
        expect(shown, hasLength(1));
        expect(shown.single.arguments['id'], 1);
        expect(shown.single.arguments['title'], 'Lab 10.5');
        expect(
          shown.single.arguments['body'],
          'Đây là thông báo demo từ ứng dụng Flutter.',
        );
        expect(
          shown.single.arguments['platformSpecifics']['channelId'],
          'lab10_notifications',
        );
        pending.complete();
      }
      await tester.pumpAndSettle();
      if (result == 'success') {
        expect(
          find.text('Đã gửi thông báo demo. Kéo thanh thông báo để xem.'),
          findsOneWidget,
        );
      } else if (result == 'revoked') {
        expect(shown, isEmpty);
        expect(
          find.text(
            'Chưa có quyền thông báo. Vui lòng cấp quyền trước khi gửi.',
          ),
          findsOneWidget,
        );
        expect(tester.widget<FilledButton>(sendButton).onPressed, isNull);
      } else {
        expect(
          find.text('Không thể gửi thông báo. Vui lòng thử lại.'),
          findsOneWidget,
        );
        expect(tester.widget<FilledButton>(sendButton).onPressed, isNotNull);
      }
    });
  }
}
