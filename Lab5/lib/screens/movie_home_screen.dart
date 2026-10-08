import 'package:flutter/material.dart';

import '../sample_data.dart';
import '../widgets/movie_image.dart';
import 'movie_detail_screen.dart';

class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Movies')),
    body: ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sampleMovies.length,
      itemBuilder: (context, index) {
        final movie = sampleMovies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => MovieDetailScreen(movie: movie),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 82,
                      height: 56,
                      child: MovieImage(url: movie.posterUrl),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text('☆ ${movie.rating} · ${movie.genres.join(', ')}'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
