import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';

void main() {
  testWidgets('Main displays the step 4 login screen', (tester) async {
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
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Đăng nhập thành công!'), findsOneWidget);
    expect(find.textContaining('mock-token-'), findsOneWidget);
    expect(find.text('Email không hợp lệ.'), findsNothing);
    expect(find.text('Mật khẩu cần ít nhất 6 ký tự.'), findsNothing);
    expect(fields, findsNWidgets(2));
  });

  testWidgets('Wrong credentials show an error and allow retry', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'student@example.com');
    await tester.enterText(fields.at(1), 'wrongpassword');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Email hoặc mật khẩu không đúng.'), findsOneWidget);
    expect(find.textContaining('mock-token-'), findsNothing);

    await tester.enterText(fields.at(1), '123456');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.text('Email hoặc mật khẩu không đúng.'), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Đăng nhập thành công!'), findsOneWidget);
    expect(find.textContaining('mock-token-'), findsOneWidget);
  });
}
