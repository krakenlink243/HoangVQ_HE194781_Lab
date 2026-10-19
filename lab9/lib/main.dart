// Lab 9 – Working With Local JSON Storage (Flutter + File Persistence)
//
//   9.1 screens/asset_products_screen.dart → rootBundle.loadString + ListView
//   9.2 screens/notes_screen.dart          → path_provider + File read/write
//   9.3 screens/student_db_screen.dart     → JSON mini-database: CRUD + search
//
// JSON files: assets/data/products.json, assets/data/students.json (seed),
// and notes.json / students.json created in the app documents directory.

import 'package:flutter/material.dart';

import 'screens/asset_products_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/student_db_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 – Local JSON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labs = <(String, String, IconData, WidgetBuilder)>[
      (
        'Lab 9.1 – Read JSON from assets',
        'products.json → ListView',
        Icons.inventory_2,
        (_) => const AssetProductsScreen(),
      ),
      (
        'Lab 9.2 – Save & load JSON file',
        'Add notes, save, restart app, still there',
        Icons.save,
        (_) => NotesScreen(),
      ),
      (
        'Lab 9.3 – JSON CRUD + Search',
        'Student mini-database with auto-save',
        Icons.storage,
        (_) => StudentDbScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9 – HE194781')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final (title, subtitle, icon, builder) in labs)
            Card(
              child: ListTile(
                leading: Icon(icon),
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: builder),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
