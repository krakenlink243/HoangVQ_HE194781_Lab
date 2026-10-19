import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

/// List screen: binds ApiService.fetchPosts() to the UI with FutureBuilder.
class PostListScreen extends StatefulWidget {
  final ApiService api;
  const PostListScreen({super.key, required this.api});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  // Stored in state so build() doesn't start a new request every rebuild.
  late Future<List<Post>> _postsFuture;

  // Posts created via POST (jsonplaceholder doesn't really save them,
  // so we keep them locally and show them on top of the list).
  final List<Post> _createdPosts = [];

  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.api.fetchPosts();
  }

  /// Starts a new request; used by Retry, pull-to-refresh and the menu.
  Future<void> _reload() {
    final future = widget.api.fetchPosts(simulateError: _simulateError);
    // Block body: an arrow `() => _postsFuture = future` would return a
    // Future, which setState() rejects – the screen would not rebuild.
    setState(() {
      _postsFuture = future;
    });
    // Swallow the error here – FutureBuilder already displays it.
    return future.then((_) {}, onError: (_) {});
  }

  Future<void> _openCreate() async {
    final created = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => CreatePostScreen(api: widget.api)),
    );
    if (created != null) setState(() => _createdPosts.insert(0, created));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
          // Toggle to demo the error state (for the screenshot).
          PopupMenuButton<String>(
            onSelected: (_) {
              _simulateError = !_simulateError;
              _reload();
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: 'error',
                checked: _simulateError,
                child: const Text('Simulate error'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: const Text('New post'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }

          // 2. Error
          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          // 3. Data
          final posts = [..._createdPosts, ...?snapshot.data];
          if (posts.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: posts.length,
              itemBuilder: (context, index) => _PostCard(
                post: posts[index],
                isNew: index < _createdPosts.length,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  final bool isNew;
  const _PostCard({required this.post, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${post.id}')),
        title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: isNew
            ? const Chip(label: Text('NEW'))
            : const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading posts...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
