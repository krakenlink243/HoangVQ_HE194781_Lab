import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import '../widgets/movie_image.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;
  int? userRating;

  Future<void> rateMovie() async {
    final rating = await showDialog<int>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Rate this movie'),
        children: [
          for (var stars = 1; stars <= 5; stars++)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, stars),
              child: Text('$stars ${stars == 1 ? 'star' : 'stars'}'),
            ),
        ],
      ),
    );
    if (rating != null && mounted) setState(() => userRating = rating);
  }

  Future<void> shareMovie() async {
    await Clipboard.setData(ClipboardData(text: widget.movie.shareText));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie details copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MovieImage(url: movie.posterUrl),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final genre in movie.genres) Chip(label: Text(genre)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(
              movie.overview,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                label: 'Favorite',
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
              _ActionButton(
                icon: userRating == null ? Icons.star_border : Icons.star,
                label: userRating == null ? 'Rate' : '$userRating/5',
                onPressed: rateMovie,
              ),
              _ActionButton(
                icon: Icons.share,
                label: 'Share',
                onPressed: shareMovie,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Text(
              'Trailers',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          for (final trailer in movie.trailers)
            ListTile(
              leading: const Icon(Icons.play_circle_fill),
              title: Text(trailer.title),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: trailer.url));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Trailer link copied to clipboard'),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      IconButton(icon: Icon(icon), onPressed: onPressed),
      Text(label),
    ],
  );
}
