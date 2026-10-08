import 'models/movie.dart';

const sampleMovies = <Movie>[
  Movie(
    id: 'dune-2',
    title: 'Dune: Part Two',
    posterUrl:
        'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=1000',
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: [
      Trailer(
        title: 'Official Trailer #1',
        url: 'https://www.youtube.com/watch?v=Way9Dexny3w',
      ),
      Trailer(
        title: 'IMAX Sneak Peek',
        url: 'https://www.youtube.com/results?search_query=Dune+Part+Two+IMAX+sneak+peek',
      ),
    ],
  ),
  Movie(
    id: 'deadpool-wolverine',
    title: 'Deadpool & Wolverine',
    posterUrl:
        'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=1000',
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: [
      Trailer(
        title: 'Red Band Trailer',
        url: 'https://www.youtube.com/results?search_query=Deadpool+and+Wolverine+Red+Band+Trailer',
      ),
      Trailer(
        title: 'Behind the Scenes',
        url: 'https://www.youtube.com/results?search_query=Deadpool+and+Wolverine+behind+the+scenes',
      ),
    ],
  ),
];
