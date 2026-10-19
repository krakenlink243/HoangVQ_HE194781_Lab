import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Storage service: reads / writes a JSON list in the app documents
/// directory (Lab 9.2 & 9.3).
class JsonFileStorage {
  final String fileName;

  /// Where the file lives. Defaults to getApplicationDocumentsDirectory();
  /// tests inject a temporary directory instead.
  final Future<Directory> Function() _directory;

  JsonFileStorage(this.fileName, {Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  /// 1. Locate the file inside the app documents directory.
  Future<File> get file async {
    final dir = await _directory();
    return File('${dir.path}/$fileName');
  }

  /// 2. Read the JSON list. If the file does not exist yet it is created,
  /// using [seed] (e.g. a JSON string from assets) or an empty list.
  Future<List<Map<String, dynamic>>> readList({
    Future<String> Function()? seed,
  }) async {
    final f = await file;
    if (!await f.exists()) {
      final initial = seed != null ? await seed() : '[]';
      await f.create(recursive: true);
      await f.writeAsString(initial);
    }

    final content = await f.readAsString();
    if (content.trim().isEmpty) return [];

    final decoded = jsonDecode(content); // String → List<dynamic>
    return (decoded as List).cast<Map<String, dynamic>>();
  }

  /// 3. Write the whole list back to the file (pretty-printed).
  Future<void> writeList(List<Map<String, dynamic>> items) async {
    final f = await file;
    const encoder = JsonEncoder.withIndent('  ');
    await f.writeAsString(encoder.convert(items)); // List → JSON String
  }

  /// Delete the file (used by "Reset to sample data").
  Future<void> delete() async {
    final f = await file;
    if (await f.exists()) await f.delete();
  }
}
