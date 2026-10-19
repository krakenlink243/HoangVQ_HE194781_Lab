import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise 1 – Core Widgets"),),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome to Flutter',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          const Icon(Icons.movie, size: 64, color: Colors.blue),
          const SizedBox(height: 16),
          Image.network(
            'https://picsum.photos/400/200',
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
            const Icon(Icons.broken_image, size: 64),
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Inception'),
              subtitle: Text('Sci-Fi • 2010'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
  
}
