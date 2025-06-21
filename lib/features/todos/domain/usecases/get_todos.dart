import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all todos
class GetTodos {
  GetTodos(this._repository);

  final TodoRepository _repository;

  /// Execute the use case
  Future<Either<Failure, List<Todo>>> call() async => _repository.getTodos();
}
