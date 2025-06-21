import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clean_architecture_template/features/todos/data/models/todo_model.dart';
import 'package:flutter_clean_architecture_template/features/todos/domain/entities/todo.dart';

void main() {
  group('TodoModel', () {
    final tTodoModel = TodoModel(
      id: '1',
      title: 'Test Todo',
      description: 'Test Description',
      isCompleted: false,
      createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
    );

    final tTodo = Todo(
      id: '1',
      title: 'Test Todo',
      description: 'Test Description',
      isCompleted: false,
      createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
    );

    test('should be a subclass of Todo entity', () {
      // Assert
      expect(tTodoModel.toEntity(), isA<Todo>());
    });

    group('fromJson', () {
      test('should return a valid model when JSON is valid', () {
        // Arrange
        final jsonMap = {
          'id': '1',
          'title': 'Test Todo',
          'description': 'Test Description',
          'isCompleted': false,
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-02T00:00:00.000Z',
        };

        // Act
        final result = TodoModel.fromJson(jsonMap);

        // Assert
        expect(result, tTodoModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tTodoModel.toJson();

        // Assert
        final expectedMap = {
          'id': '1',
          'title': 'Test Todo',
          'description': 'Test Description',
          'isCompleted': false,
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-02T00:00:00.000Z',
        };
        expect(result, expectedMap);
      });
    });

    group('toEntity', () {
      test('should return a Todo entity with proper data', () {
        // Act
        final result = tTodoModel.toEntity();

        // Assert
        expect(result, tTodo);
      });
    });

    group('fromEntity', () {
      test('should return a TodoModel with proper data', () {
        // Act
        final result = TodoModel.fromEntity(tTodo);

        // Assert
        expect(result, tTodoModel);
      });
    });
  });
}
