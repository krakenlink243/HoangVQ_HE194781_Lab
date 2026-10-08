import 'package:flutter/material.dart';

class AppStructureDemo extends StatefulWidget {
  const AppStructureDemo({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<AppStructureDemo> createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  late bool isDarkMode = widget.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 – App Structure'),
        actions: [
          const Center(child: Text('Dark')),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() => isDarkMode = value);
              widget.onDarkModeChanged(value);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('This is a simple screen with theme toggle.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FloatingActionButton pressed')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
