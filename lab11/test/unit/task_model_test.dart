import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  test('Task completed defaults to false', () {
    final task = Task(id: '1', title: 'Learn Flutter testing');

    final completed = task.completed;

    expect(completed, isFalse);
  });
}
