import 'package:flutter/material.dart';

import 'services/notification_service.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.5 - Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _service = NotificationService();
  late final Future<bool> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.5 · Notification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<bool>(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              final message = snapshot.hasError
                  ? 'Không thể khởi tạo thông báo. Vui lòng mở lại ứng dụng.'
                  : snapshot.data == true
                  ? 'Đã khởi tạo local notifications.'
                  : 'Hãy chạy trên Android để thực hành thông báo.';
              return Text(message, textAlign: TextAlign.center);
            },
          ),
        ),
      ),
    );
  }
}
