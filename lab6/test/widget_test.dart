import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab6/main.dart';

void main() {
  testWidgets('Search combines with genre toggles and handles no results', (
    tester,
  ) async {
    await tester.pumpWidget(const ResponsiveMovieApp());
    await tester.enterText(find.byType(TextField), '  INTER  ');
    await tester.pump();
    expect(find.text('1 movies to explore'), findsOneWidget);
    expect(
      tester.widget<MovieCard>(find.byType(MovieCard)).movie.title,
      'Interstellar',
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Comedy'));
    await tester.pump();
    expect(find.text('No movies found'), findsOneWidget);

    // Multiple genres use OR; search and the genre group use AND.
    await tester.tap(find.widgetWithText(FilterChip, 'Drama'));
    await tester.pump();
    expect(find.text('1 movies to explore'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilterChip, 'Drama'));
    await tester.pump();
    expect(find.text('No movies found'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilterChip, 'Comedy'));
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    expect(find.text('6 movies to explore'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Every sort option changes the displayed order', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ResponsiveMovieApp());
    await tester.pump();

    List<String> titles() => tester
        .widgetList<MovieCard>(find.byType(MovieCard))
        .map((card) => card.movie.title)
        .toList();
    expect(titles(), [
      'Dune',
      'Inside Out',
      'Interstellar',
      'Soul',
      'The Dark Knight',
      'The Grand Budapest Hotel',
    ]);

    for (final entry in {
      MovieSort.titleDescending: [
        'The Grand Budapest Hotel',
        'The Dark Knight',
        'Soul',
        'Interstellar',
        'Inside Out',
        'Dune',
      ],
      MovieSort.year: [
        'Dune',
        'Soul',
        'Inside Out',
        'Interstellar',
        'The Grand Budapest Hotel',
        'The Dark Knight',
      ],
      MovieSort.rating: [
        'The Dark Knight',
        'Interstellar',
        'Inside Out',
        'The Grand Budapest Hotel',
        'Dune',
        'Soul',
      ],
    }.entries) {
      await tester.tap(find.byType(DropdownButton<MovieSort>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(entry.key.label).last);
      await tester.pumpAndSettle();
      expect(titles(), entry.value);
    }
    expect(allMovies.first.title, 'Interstellar');
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 800.0, 1200.0]) {
    testWidgets('Movie screen lays out at width $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ResponsiveMovieApp());
      await tester.pump();

      expect(find.text('Find a Movie'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FilterChip), findsNWidgets(movieGenres.length));
      expect(
        find.byType(SliverGrid),
        width >= 800 ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
