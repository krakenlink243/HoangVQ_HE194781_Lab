import 'package:flutter_test/flutter_test.dart';
import 'package:lab10/main.dart';

void main() {
  testWidgets('Main opens the Lab 10.3 login screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lab 10.3 · Auto Login & Logout'), findsOneWidget);
    expect(find.text('Đăng nhập DummyJSON'), findsOneWidget);
  });
}
