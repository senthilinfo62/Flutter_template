// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for updating a todo
class UpdateTodo {
  UpdateTodo(this._repository);

  final TodoRepository _repository;

  /// Execute the use case
  Future<Either<Failure, Todo>> call(Todo todo) async =>
      _repository.updateTodo(todo);
}
