/// Model for one item of https://jsonplaceholder.typicode.com/posts
///
/// Sample JSON:
/// {
///   "userId": 1,
///   "id": 1,
///   "title": "sunt aut facere ...",
///   "body": "quia et suscipit ..."
/// }
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// JSON map → Post (Lab 8.2)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Post → JSON map, used as the body of the POST request.
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'body': body,
  };
}
