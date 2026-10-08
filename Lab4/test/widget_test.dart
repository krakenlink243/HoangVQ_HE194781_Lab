import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4/main.dart';

void main() {
  testWidgets('Exercise 4 switches the app theme', (tester) async {
    await tester.pumpWidget(const Lab4App());
    await tester.tap(find.text('Exercise 4 – App Structure & Theme'));
    await tester.pumpAndSettle();

    expect(
      find.text('This is a simple screen with theme toggle.'),
      findsOneWidget,
    );
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}
