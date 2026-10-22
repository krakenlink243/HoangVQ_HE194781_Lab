import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab10_3_auto_login_logout/main.dart';
import 'package:lab10_3_auto_login_logout/screens/home_screen.dart';
import 'package:lab10_3_auto_login_logout/screens/login_screen.dart';

void main() {
  for (final token in <String?>[null, '', '   ', 'saved-access-token']) {
    testWidgets('Splash restores session for token: $token', (tester) async {
      SharedPreferences.setMockInitialValues({'token': ?token});
      await tester.pumpWidget(const MainApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      if (token == 'saved-access-token') {
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.text('saved-access-token'), findsOneWidget);
        expect(find.text('Chào mừng trở lại!'), findsOneWidget);
        expect(find.byType(LoginScreen), findsNothing);
      } else {
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(HomeScreen), findsNothing);
      }
      expect(
        tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
        isFalse,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  }

  testWidgets('A saved token survives rebuilding the app', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', 'persisted-token');
    await tester.pumpWidget(const MainApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MainApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('persisted-token'), findsOneWidget);
  });

  testWidgets('Logout clears token and requires login after restart', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'token': 'saved-access-token',
      'theme': 'teal',
    });
    await tester.pumpWidget(const MainApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Đăng xuất'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('token'), isNull);
    expect(preferences.getString('theme'), 'teal');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MainApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });
}
