import 'package:flutter/material.dart';

void main() => runApp(const ResponsiveMovieApp());

/// Sample data lives in this file so the demo can also run in DartPad.
class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });

  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;
}

enum MovieSort {
  titleAscending('A–Z'),
  titleDescending('Z–A'),
  year('Year'),
  rating('Rating');

  const MovieSort(this.label);
  final String label;
}

const movieGenres = [
  'Action',
  'Drama',
  'Comedy',
  'Sci-Fi',
  'Adventure',
  'Animation',
];

const allMovies = <Movie>[
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/interstellar/300/450',
    rating: 8.7,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/darkknight/300/450',
    rating: 9.0,
  ),
  Movie(
    title: 'Inside Out',
    year: 2015,
    genres: ['Animation', 'Comedy', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/insideout/300/450',
    rating: 8.1,
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: ['Comedy', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/budapest/300/450',
    rating: 8.1,
  ),
  Movie(
    title: 'Dune',
    year: 2021,
    genres: ['Sci-Fi', 'Adventure', 'Action'],
    posterUrl: 'https://picsum.photos/seed/dune/300/450',
    rating: 8.0,
  ),
  Movie(
    title: 'Soul',
    year: 2020,
    genres: ['Animation', 'Drama', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/soul/300/450',
    rating: 8.0,
  ),
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6355D9)),
        scaffoldBackgroundColor: const Color(0xFFF6F5FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  MovieSort selectedSort = MovieSort.titleAscending;

  List<Movie> get visibleMovies {
    final query = searchQuery.trim().toLowerCase();
    final movies = allMovies.where((movie) {
      return movie.title.toLowerCase().contains(query) &&
          (selectedGenres.isEmpty || movie.genres.any(selectedGenres.contains));
    }).toList();

    movies.sort((a, b) {
      final comparison = switch (selectedSort) {
        MovieSort.titleAscending => a.title.compareTo(b.title),
        MovieSort.titleDescending => b.title.compareTo(a.title),
        MovieSort.year => b.year.compareTo(a.year),
        MovieSort.rating => b.rating.compareTo(a.rating),
      };
      // Titles give equal years/ratings a consistent order.
      return comparison == 0 ? a.title.compareTo(b.title) : comparison;
    });
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    final movies = visibleMovies;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;
            final padding = isWide ? 32.0 : 20.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(padding, 28, padding, 20),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_movies_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'MOVIE EXPLORER',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Find a Movie',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Discover your next favorite story.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              onChanged: (value) =>
                                  setState(() => searchQuery = value),
                              decoration: const InputDecoration(
                                hintText: 'Search movies by title…',
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Browse by genre',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final genre in movieGenres)
                                  FilterChip(
                                    selected: selectedGenres.contains(genre),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedGenres.add(genre);
                                        } else {
                                          selectedGenres.remove(genre);
                                        }
                                      });
                                    },
                                    label: Text(genre),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 20,
                              runSpacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${movies.length} movies to explore',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Sort by'),
                                    const SizedBox(width: 12),
                                    DropdownButton<MovieSort>(
                                      value: selectedSort,
                                      items: [
                                        for (final sort in MovieSort.values)
                                          DropdownMenuItem(
                                            value: sort,
                                            child: Text(sort.label),
                                          ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() => selectedSort = value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(padding, 0, padding, 28),
                      sliver: movies.isEmpty
                          ? const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Column(
                                  children: [
                                    Icon(Icons.search_off, size: 48),
                                    SizedBox(height: 12),
                                    Text('No movies found'),
                                    SizedBox(height: 6),
                                    Text('Try another title or genre.'),
                                  ],
                                ),
                              ),
                            )
                          : isWide
                          ? SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    mainAxisExtent: 220,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    MovieCard(movie: movies[index]),
                                childCount: movies.length,
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: MovieCard(movie: movies[index]),
                                ),
                                childCount: movies.length,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posterWidth = constraints.maxWidth < 350 ? 88.0 : 112.0;
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.posterUrl,
                    width: posterWidth,
                    height: posterWidth * 1.5,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: posterWidth,
                      height: posterWidth * 1.5,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.movie_outlined, size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${movie.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.genres.join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFE8A438),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
