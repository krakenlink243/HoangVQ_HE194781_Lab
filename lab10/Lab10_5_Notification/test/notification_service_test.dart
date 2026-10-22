import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab10_5_notification/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return call.method == 'initialize' ? true : null;
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'Initializes Android icon and channel without requesting permission',
    () async {
      expect(await NotificationService().initialize(), isTrue);
      expect(calls.map((call) => call.method), [
        'initialize',
        'createNotificationChannel',
      ]);
      expect(calls.first.arguments['defaultIcon'], 'ic_notification');
      expect(calls.last.arguments['id'], 'lab10_notifications');
    },
  );

  test('Reports initialization failure', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => false);
    await expectLater(NotificationService().initialize(), throwsStateError);
  });
}
