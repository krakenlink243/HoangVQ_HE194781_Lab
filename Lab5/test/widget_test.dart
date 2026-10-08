import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/main.dart';

void main() {
  testWidgets('opens movie details and returns to the list', (tester) async {
    await tester.pumpWidget(const MovieApp());

    expect(find.text('Dune: Part Two'), findsOneWidget);
    expect(find.text('Deadpool & Wolverine'), findsOneWidget);

    await tester.tap(find.text('Dune: Part Two'));
    await tester.pumpAndSettle();

    expect(find.text('Trailers'), findsOneWidget);
    expect(find.text('Sci-Fi'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Deadpool & Wolverine'), findsOneWidget);
  });
}
