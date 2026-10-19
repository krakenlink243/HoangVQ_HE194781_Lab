import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab9/main.dart';
import 'package:lab9/models/student.dart';
import 'package:lab9/screens/asset_products_screen.dart';
import 'package:lab9/screens/student_db_screen.dart';
import 'package:lab9/services/json_file_storage.dart';

/// Lets real file I/O finish inside a widget test (it runs outside FakeAsync).
Future<void> settleIo(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  late Directory tempDir;

  setUp(() => tempDir = Directory.systemTemp.createTempSync('lab9_'));
  tearDown(() => tempDir.deleteSync(recursive: true));

  JsonFileStorage storageFor(String name) =>
      JsonFileStorage(name, directory: () async => tempDir);

  group('JsonFileStorage (9.2)', () {
    test('creates file from seed when missing', () async {
      final storage = storageFor('a.json');
      final rows = await storage.readList(seed: () async => '[{"id":1}]');
      expect(rows, [
        {'id': 1},
      ]);
      expect(await (await storage.file).exists(), isTrue);
    });

    test('data written is read back (persists across instances)', () async {
      await storageFor('b.json').writeList([
        {'id': 7, 'text': 'hello'},
      ]);
      // A new instance = "app restarted".
      final rows = await storageFor('b.json').readList();
      expect(rows.single['text'], 'hello');
    });
  });

  test('Student JSON round trip', () {
    const s = Student(id: 1, name: 'A', major: 'SE', gpa: 3.5);
    final back = Student.fromJson(
      jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>,
    );
    expect(back.name, 'A');
    expect(back.gpa, 3.5);
  });

  testWidgets('home shows the 3 labs', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.textContaining('Lab 9.1'), findsOneWidget);
    expect(find.textContaining('Lab 9.2'), findsOneWidget);
    expect(find.textContaining('Lab 9.3'), findsOneWidget);
  });

  testWidgets('9.1 loads products.json from assets', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AssetProductsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Wireless Mouse'), findsOneWidget);
    expect(find.text('199.000 ₫'), findsOneWidget);
  });

  testWidgets('9.3 search, add (auto-save) and delete', (tester) async {
    final storage = storageFor('students.json');
    await tester.runAsync(
      () => storage.writeList([
        const Student(id: 1, name: 'Alice', major: 'SE', gpa: 3.2).toJson(),
        const Student(id: 2, name: 'Bob', major: 'AI', gpa: 3.9).toJson(),
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(home: StudentDbScreen(storage: storage)),
    );
    await settleIo(tester);
    expect(find.text('Alice'), findsOneWidget);

    // Search
    await tester.enterText(find.byType(TextField), 'ai');
    await tester.pump();
    expect(find.text('Alice'), findsNothing);
    expect(find.text('Bob'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    // Add
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    final fields = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(fields.at(0), 'Charlie');
    await tester.enterText(fields.at(1), 'IA');
    await tester.enterText(fields.at(2), '3.0');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    await settleIo(tester);
    expect(find.text('Charlie'), findsOneWidget);

    final saved = await tester.runAsync(() => storage.readList());
    expect(saved!.map((e) => e['name']), contains('Charlie'));
    expect(saved.last['id'], 3); // auto-incremented

    // Delete with confirmation
    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pump();
    await settleIo(tester);
    expect(find.text('Alice'), findsNothing);
    final afterDelete = await tester.runAsync(() => storage.readList());
    expect(afterDelete!.length, 2);
  });
}
