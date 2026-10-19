import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab7/main.dart';

void main() {
  group('validators', () {
    test('name', () {
      expect(validateName(''), 'Name is required');
      expect(validateName('An'), isNull);
    });
    test('email', () {
      expect(validateEmail(''), 'Email is required');
      expect(validateEmail('abc'), 'Enter a valid email');
      expect(validateEmail('a@b'), 'Enter a valid email');
      expect(validateEmail('a@b.com'), isNull);
    });
    test('password', () {
      expect(validatePassword('abc1'), contains('8 characters'));
      expect(validatePassword('abcdefgh'), contains('digit'));
      expect(validatePassword('abcdefg1'), isNull);
    });
    test('confirm', () {
      expect(validateConfirmPassword('x', 'y'), 'Passwords do not match');
      expect(validateConfirmPassword('abc', 'abc'), isNull);
    });
  });

  testWidgets('empty submit shows inline errors', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Sign up'));
    await tester.pump();
    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
  });

  Future<void> fillForm(WidgetTester tester, String email) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nguyen Van A');
    await tester.enterText(fields.at(1), email);
    await tester.enterText(fields.at(2), 'password1');
    await tester.enterText(fields.at(3), 'password1');
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.text('Sign up'));
    await tester.pump();
  }

  testWidgets('valid form shows success after async check', (tester) async {
    await tester.pumpWidget(const MyApp());
    await fillForm(tester, 'a@b.com');
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.textContaining('Account created'), findsOneWidget);
  });

  testWidgets('taken email shows error', (tester) async {
    await tester.pumpWidget(const MyApp());
    await fillForm(tester, 'taken@b.com');
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('This email is already taken'), findsOneWidget);
  });
}
