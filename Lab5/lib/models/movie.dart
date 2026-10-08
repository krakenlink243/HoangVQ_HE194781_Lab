class Trailer {
  const Trailer({required this.title, required this.url});
  final String title;
  final String url;
}

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });

  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;

  String get shareText => '$title — $rating/10\n$overview';
}
