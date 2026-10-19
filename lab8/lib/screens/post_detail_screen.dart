import 'package:flutter/material.dart';

import '../models/post.dart';

/// Detail screen shown when tapping a post (Bonus).
class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Post #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 18),
              const SizedBox(width: 4),
              Text('User ${post.userId}', style: textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.title, style: textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(post.body, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
