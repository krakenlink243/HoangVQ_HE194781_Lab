import 'package:flutter/material.dart';
// import 'package:lab10_1_mock_login/main.dart' as lab10_1;
// import 'package:lab10_2_real_api_login/main.dart' as lab10_2;
// import 'package:lab10_3_auto_login_logout/main.dart' as lab10_3;
import 'package:lab10_5_notification/main.dart' as lab10_5;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const lab10_1.MockLoginApp();
    // return const lab10_2.MainApp();
    // return const lab10_3.MainApp();
    return const lab10_5.MainApp();

  }
}
