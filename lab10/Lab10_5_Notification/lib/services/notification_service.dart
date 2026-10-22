import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<bool> initialize() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return false;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
    );
    final initialized = await _plugin.initialize(settings: settings);
    if (initialized != true) {
      throw StateError('Không thể khởi tạo thông báo.');
    }
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .createNotificationChannel(
          const AndroidNotificationChannel(
            'lab10_notifications',
            'Lab 10 Notifications',
            description: 'Thông báo của Lab 10.5',
            importance: Importance.high,
          ),
        );
    return true;
  }
}
