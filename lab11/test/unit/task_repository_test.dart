import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  group('TaskRepository', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask adds a task and preserves existing tasks', () {
      final existingTask = Task(id: '1', title: 'First task');
      final newTask = Task(id: '2', title: 'Second task');
      repository.addTask(existingTask);

      repository.addTask(newTask);

      expect(repository.tasks, hasLength(2));
      expect(repository.tasks, orderedEquals([existingTask, newTask]));
      expect(repository.tasks.last.title, 'Second task');
      expect(repository.tasks.last.completed, isFalse);
    });

    test('deleteTask removes the matching task and preserves other tasks', () {
      final taskToDelete = Task(id: '1', title: 'Task to delete');
      final taskToKeep = Task(id: '2', title: 'Task to keep');
      repository.addTask(taskToDelete);
      repository.addTask(taskToKeep);

      repository.deleteTask(taskToDelete.id);

      expect(repository.tasks, hasLength(1));
      expect(repository.tasks.single, same(taskToKeep));
      expect(
        repository.tasks.any((task) => task.id == taskToDelete.id),
        isFalse,
      );
    });

    test('updateTask updates by id and preserves other tasks', () {
      final originalTask = Task(id: '1', title: 'Original title');
      final otherTask = Task(id: '2', title: 'Other task');
      final updatedTask = Task(
        id: '1',
        title: 'Updated title',
        completed: true,
      );
      repository.addTask(originalTask);
      repository.addTask(otherTask);

      repository.updateTask(updatedTask);

      expect(repository.tasks, hasLength(2));
      expect(repository.tasks.first.id, originalTask.id);
      expect(repository.tasks.first.title, 'Updated title');
      expect(repository.tasks.first.completed, isTrue);
      expect(repository.tasks.last, same(otherTask));
    });
  });
}
