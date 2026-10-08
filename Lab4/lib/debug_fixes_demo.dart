import 'package:flutter/material.dart';

class DebugFixesDemo extends StatefulWidget {
  const DebugFixesDemo({super.key});

  @override
  State<DebugFixesDemo> createState() => _DebugFixesDemoState();
}

class _DebugFixesDemoState extends State<DebugFixesDemo> {
  int count = 0;
  DateTime? selectedDate;
  final items = List.generate(12, (index) => 'Movie ${index + 1}');

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    setState(() => selectedDate = date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 – Debug & Fix')),
      // Scrolling prevents the controls from overflowing on a short screen.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('State update with setState'),
            Row(
              children: [
                Text('Count: $count'),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => count++),
                  child: const Text('Increase'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('DatePicker from a valid screen context'),
            ElevatedButton(
              onPressed: pickDate,
              child: const Text('Choose date'),
            ),
            Text(
              selectedDate == null
                  ? 'No date selected'
                  : 'Selected: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            ),
            const SizedBox(height: 16),
            const Text('ListView inside Column'),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              child: Column(
                children: [
                  // Expanded gives the nested ListView a bounded height.
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.movie),
                        title: Text(items[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
