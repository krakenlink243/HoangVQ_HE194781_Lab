import 'package:flutter/material.dart';

class MovieImage extends StatelessWidget {
  const MovieImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => const ColoredBox(
      color: Color(0xFFDED9E7),
      child: Center(child: Icon(Icons.movie, size: 36)),
    ),
  );
}
