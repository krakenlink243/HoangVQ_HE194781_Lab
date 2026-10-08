import 'package:flutter/material.dart';

import 'screens/movie_home_screen.dart';

void main() => runApp(const MovieApp());

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Movies',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFAF8FF),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF635B72)),
    ),
    home: const MovieHomeScreen(),
  );
}
