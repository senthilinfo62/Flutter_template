// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';

/// Abstract repository for todo operations
abstract class TodoRepository {
  /// Get all todos
  Future<Either<Failure, List<Todo>>> getTodos();

  /// Get a specific todo by id
  Future<Either<Failure, Todo>> getTodoById(String id);

  /// Create a new todo
  Future<Either<Failure, Todo>> createTodo({
    required String title,
    required String description,
  });

  /// Update an existing todo
  Future<Either<Failure, Todo>> updateTodo(Todo todo);

  /// Delete a todo
  Future<Either<Failure, void>> deleteTodo(String id);

  /// Toggle todo completion status
  Future<Either<Failure, Todo>> toggleTodoCompletion(String id);

  /// Get completed todos
  Future<Either<Failure, List<Todo>>> getCompletedTodos();

  /// Get pending todos
  Future<Either<Failure, List<Todo>>> getPendingTodos();

  /// Search todos by title or description
  Future<Either<Failure, List<Todo>>> searchTodos(String query);
}
