import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/json_file_storage.dart';

/// Lab 9.2 – Add items, press Save to write notes.json, reload on restart.
class NotesScreen extends StatefulWidget {
  final JsonFileStorage storage;
  NotesScreen({super.key, JsonFileStorage? storage})
    : storage = storage ?? JsonFileStorage('notes.json');

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _textController = TextEditingController();
  List<Note> _notes = [];
  bool _loading = true;
  String? _error; // e.g. web (no file system) or corrupted JSON
  bool _hasUnsavedChanges = false;
  String _filePath = '';

  @override
  void initState() {
    super.initState();
    _load(); // Step 3: load data at startup
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final List<Map<String, dynamic>> rows;
    try {
      rows = await widget.storage.readList();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not read the JSON file.\n$e';
        _loading = false;
      });
      return;
    }
    final file = await widget.storage.file;
    if (!mounted) return;
    setState(() {
      _notes = rows.map(Note.fromJson).toList();
      _filePath = file.path;
      _loading = false;
      _error = null;
      _hasUnsavedChanges = false;
    });
  }

  // Step 4: TextField + Add button → append to the in-memory list.
  void _addNote() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final nextId = _notes.isEmpty
        ? 1
        : _notes.map((n) => n.id).reduce((a, b) => a > b ? a : b) + 1;
    setState(() {
      _notes.add(Note(id: nextId, text: text, createdAt: DateTime.now()));
      _hasUnsavedChanges = true;
    });
    _textController.clear();
  }

  void _removeNote(Note note) {
    setState(() {
      _notes.remove(note);
      _hasUnsavedChanges = true;
    });
  }

  // Step 5: write the list to the JSON file and confirm.
  Future<void> _save() async {
    await widget.storage.writeList(_notes.map((n) => n.toJson()).toList());
    if (!mounted) return;
    setState(() => _hasUnsavedChanges = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${_notes.length} note(s) to notes.json')),
    );
  }

  Future<void> _reloadFromFile() async {
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reloaded ${_notes.length} note(s) from file')),
    );
  }

  String _formatTime(DateTime t) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.day)}/${two(t.month)}/${t.year} ${two(t.hour)}:${two(t.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('9.2 – Notes (file storage)'),
        actions: [
          IconButton(
            tooltip: 'Reload from file',
            icon: const Icon(Icons.restore),
            onPressed: _reloadFromFile,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: Text(_hasUnsavedChanges ? 'Save *' : 'Save'),
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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            labelText: 'New note',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addNote(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _addNote,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ),
                if (_hasUnsavedChanges)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'You have unsaved changes – press Save.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                Expanded(
                  child: _notes.isEmpty
                      ? const Center(
                          child: Text('No notes yet. Add one above.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                          itemCount: _notes.length,
                          itemBuilder: (context, i) {
                            final note = _notes[i];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${note.id}'),
                                ),
                                title: Text(note.text),
                                subtitle: Text(_formatTime(note.createdAt)),
                                trailing: IconButton(
                                  tooltip: 'Remove',
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _removeNote(note),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Shows where the JSON file lives – useful for the report.
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Text(
                    'File: $_filePath',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}
