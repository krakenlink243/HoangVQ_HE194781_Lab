import 'package:flutter/material.dart';

import 'app_structure_demo.dart';
import 'core_widgets_demo.dart';
import 'debug_fixes_demo.dart';
import 'input_controls_demo.dart';
import 'music_ui.dart';

void main() => runApp(const Lab4App());

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: const Text('Lab 4 – Flutter UI Fundamentals')),
        body: Builder(
          builder: (context) => ListView(
            children: [
              ListTile(
                title: const Text('Exercise 1 – Core Widgets'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CoreWidgetsDemo()),
                ),
              ),
              ListTile(
                title: const Text('Exercise 2 – Input Widgets'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InputControlsDemo()),
                ),
              ),
              ListTile(
                title: const Text('Exercise 3 – Layout'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MusicUi()),
                ),
              ),
              ListTile(
                title: const Text('Exercise 4 – App Structure & Theme'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppStructureDemo(
                      isDarkMode: isDarkMode,
                      onDarkModeChanged: (value) {
                        setState(() => isDarkMode = value);
                      },
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Exercise 5 – Debug & Fix'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DebugFixesDemo()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
