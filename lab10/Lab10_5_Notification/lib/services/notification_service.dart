import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<bool> showDemoNotification() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (await android?.areNotificationsEnabled() != true) return false;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'lab10_notifications',
        'Lab 10 Notifications',
        channelDescription: 'Thông báo của Lab 10.5',
        icon: 'ic_notification',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(
      id: 1,
      title: 'Lab 10.5',
      body: 'Đây là thông báo demo từ ứng dụng Flutter.',
      notificationDetails: details,
    );
    return true;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? false;
  }

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
