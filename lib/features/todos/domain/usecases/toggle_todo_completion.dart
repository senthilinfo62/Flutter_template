// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for toggling todo completion status
class ToggleTodoCompletion {
  ToggleTodoCompletion(this._repository);

  final TodoRepository _repository;

  /// Execute the use case
  Future<Either<Failure, Todo>> call(String id) async =>
      _repository.toggleTodoCompletion(id);
}
