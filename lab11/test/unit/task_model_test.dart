import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  test('Task completed defaults to false', () {
    final task = Task(id: '1', title: 'Learn Flutter testing');

    final completed = task.completed;

    expect(completed, isFalse);
  });

  test('toggle changes completed from false to true', () {
    final task = Task(id: '1', title: 'Learn Flutter testing');

    task.toggle();

    expect(task.completed, isTrue);
  });

  test('toggle changes completed from true to false', () {
    final task = Task(id: '1', title: 'Learn Flutter testing', completed: true);

    task.toggle();

    expect(task.completed, isFalse);
  });

  test('toggling twice restores the original completed value', () {
    final task = Task(id: '1', title: 'Learn Flutter testing');

    task.toggle();
    task.toggle();

    expect(task.completed, isFalse);
    expect(task.id, '1');
    expect(task.title, 'Learn Flutter testing');
  });
}
