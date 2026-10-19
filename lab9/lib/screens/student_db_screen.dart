import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/student.dart';
import '../services/json_file_storage.dart';
import '../widgets/student_form_dialog.dart';

/// Lab 9.3 – students.json as a local mini-database:
/// add / edit / delete / search, auto-saved after every change.
class StudentDbScreen extends StatefulWidget {
  final JsonFileStorage storage;
  StudentDbScreen({super.key, JsonFileStorage? storage})
    : storage = storage ?? JsonFileStorage('students.json');

  @override
  State<StudentDbScreen> createState() => _StudentDbScreenState();
}

class _StudentDbScreenState extends State<StudentDbScreen> {
  // Step 1: in-memory list loaded from the JSON file.
  List<Student> _students = [];
  String _query = '';
  bool _loading = true;
  String? _error; // e.g. web (no file system) or corrupted JSON

  // First run: the file is created from the bundled sample JSON.
  Future<String> _seed() => rootBundle.loadString('assets/data/students.json');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<Map<String, dynamic>> rows;
    try {
      rows = await widget.storage.readList(seed: _seed);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not read the JSON file.\n$e';
        _loading = false;
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      _students = rows.map(Student.fromJson).toList();
      _loading = false;
      _error = null;
    });
  }

  // Step 4: auto-save after each CRUD action.
  Future<void> _persist(String message) async {
    await widget.storage.writeList(_students.map((s) => s.toJson()).toList());
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$message • saved to JSON')));
  }

  /// Auto-incremented id: max existing id + 1.
  int get _nextId => _students.isEmpty
      ? 1
      : _students.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;

  // Step 2: filter by name or major (case-insensitive).
  List<Student> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _students;
    return _students
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.major.toLowerCase().contains(q),
        )
        .toList();
  }

  // Step 3: Add
  Future<void> _add() async {
    final result = await showStudentFormDialog(context);
    if (result == null) return;
    final student = Student(
      id: _nextId,
      name: result.name,
      major: result.major,
      gpa: result.gpa,
    );
    setState(() => _students.add(student));
    await _persist('Added "${student.name}"');
  }

  // Step 3: Edit
  Future<void> _edit(Student student) async {
    final result = await showStudentFormDialog(context, initial: student);
    if (result == null) return;
    setState(() {
      final index = _students.indexWhere((s) => s.id == student.id);
      _students[index] = student.copyWith(
        name: result.name,
        major: result.major,
        gpa: result.gpa,
      );
    });
    await _persist('Updated "${result.name}"');
  }

  // Step 3: Delete (after confirmation)
  Future<void> _delete(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text('"${student.name}" will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _students.removeWhere((s) => s.id == student.id));
    await _persist('Deleted "${student.name}"');
  }

  Future<void> _resetToSample() async {
    await widget.storage.delete();
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database reset to sample data')),
    );
  }

  Color _gpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 3.0) return Colors.blue;
    if (gpa >= 2.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('9.3 – Student DB (CRUD)'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (_) => _resetToSample(),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'reset',
                child: Text('Reset to sample data'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add student',
        onPressed: _loading ? null : _add,
        child: const Icon(Icons.person_add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or major',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixText: '${items.length}/${_students.length}',
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                Expanded(
                  // Pull-to-refresh reloads from the JSON file (bonus).
                  child: RefreshIndicator(
                    onRefresh: _load,
                    child: items.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('No students found.')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              final s = items[i];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(child: Text('${s.id}')),
                                  title: Text(s.name),
                                  subtitle: Text(s.major),
                                  onTap: () => _edit(s),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Chip(
                                        label: Text(
                                          s.gpa.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: _gpaColor(s.gpa),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Delete',
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _delete(s),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
