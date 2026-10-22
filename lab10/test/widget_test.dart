import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';

void main() {
  testWidgets('Main displays the step 3 login screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Mật khẩu'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Đăng nhập'), findsOneWidget);
  });
  testWidgets('Form validates inputs and clears errors after correction', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final button = find.widgetWithText(FilledButton, 'Đăng nhập');
    final fields = find.byType(TextFormField);

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);

    await tester.enterText(fields.at(0), 'invalid');
    await tester.enterText(fields.at(1), '123');
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Email không hợp lệ.'), findsOneWidget);
    expect(find.text('Mật khẩu cần ít nhất 6 ký tự.'), findsOneWidget);

    await tester.enterText(fields.at(0), 'student@example.com');
    await tester.enterText(fields.at(1), '123456');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Email không hợp lệ.'), findsNothing);
    expect(find.text('Mật khẩu cần ít nhất 6 ký tự.'), findsNothing);
    expect(fields, findsNWidgets(2));
  });
}
