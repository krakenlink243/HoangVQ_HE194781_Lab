import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task', () {
    late Task task;

    setUp(() {
      task = Task(id: '1', title: 'Learn Flutter testing');
    });

    test('completed defaults to false', () {
      final completed = task.completed;

      expect(completed, isFalse);
    });

    test('toggle changes completed from false to true', () {
      task.toggle();

      expect(task.completed, isTrue);
    });

    test('toggle changes completed from true to false', () {
      task.completed = true;

      task.toggle();

      expect(task.completed, isFalse);
    });

    test('toggling twice restores the original completed value', () {
      final originalCompleted = task.completed;
      final originalId = task.id;
      final originalTitle = task.title;

      task.toggle();
      task.toggle();

      expect(task.completed, originalCompleted);
      expect(task.id, originalId);
      expect(task.title, originalTitle);
    });
  });
}
