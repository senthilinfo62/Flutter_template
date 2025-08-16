// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for creating a new todo
class CreateTodo {
  CreateTodo(this._repository);

  final TodoRepository _repository;

  /// Execute the use case
  Future<Either<Failure, Todo>> call(CreateTodoParams params) async =>
      _repository.createTodo(
        title: params.title,
        description: params.description,
      );
}

/// Parameters for creating a todo
class CreateTodoParams extends Equatable {
  const CreateTodoParams({required this.title, required this.description});

  final String title;
  final String description;

  @override
  List<Object> get props => [title, description];
}
