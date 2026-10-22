import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';

void main() {
  testWidgets('Main opens Lab 10.5 notification setup', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Lab 10.5 · Notification'), findsOneWidget);
  });
}
