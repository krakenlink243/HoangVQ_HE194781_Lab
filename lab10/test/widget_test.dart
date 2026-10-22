import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Main opens Splash then replaces it with Login', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lab 10.3'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Đăng nhập DummyJSON'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Lab 10.3 · Auto Login & Logout'), findsOneWidget);
    expect(find.text('Đăng nhập DummyJSON'), findsOneWidget);
    expect(find.text('Lab 10.3'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
  });
}
