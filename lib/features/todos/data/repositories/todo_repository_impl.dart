import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

/// Implementation of TodoRepository
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      // Try to get from remote first
      try {
        final remoteTodos = await remoteDataSource.getTodos();
        await localDataSource.cacheTodos(remoteTodos);
        return Right(remoteTodos.map((model) => model.toEntity()).toList());
      } on Exception {
        // If remote fails, get from local cache
        final localTodos = await localDataSource.getTodos();
        return Right(localTodos.map((model) => model.toEntity()).toList());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String id) async {
    try {
      // Try remote first, fallback to local
      try {
        final remoteTodo = await remoteDataSource.getTodoById(id);
        return Right(remoteTodo.toEntity());
      } on Exception {
        final localTodo = await localDataSource.getTodoById(id);
        return Right(localTodo.toEntity());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> createTodo({
    required String title,
    required String description,
  }) async {
    try {
      // Create locally first for offline support
      final localTodo = await localDataSource.createTodo(
        title: title,
        description: description,
      );

      // Try to sync with remote
      try {
        final remoteTodo = await remoteDataSource.createTodo(
          title: title,
          description: description,
        );
        // Update local with remote data
        await localDataSource.updateTodo(remoteTodo);
        return Right(remoteTodo.toEntity());
      } on Exception {
        // Return local todo if remote fails
        return Right(localTodo.toEntity());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);

      // Update locally first
      final localTodo = await localDataSource.updateTodo(todoModel);

      // Try to sync with remote
      try {
        final remoteTodo = await remoteDataSource.updateTodo(todoModel);
        await localDataSource.updateTodo(remoteTodo);
        return Right(remoteTodo.toEntity());
      } on Exception {
        // Return local todo if remote fails
        return Right(localTodo.toEntity());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      // Delete locally first
      await localDataSource.deleteTodo(id);

      // Try to sync with remote
      try {
        await remoteDataSource.deleteTodo(id);
      } on Exception {
        // Ignore remote errors for delete operations
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> toggleTodoCompletion(String id) async {
    try {
      final todoResult = await getTodoById(id);
      return todoResult.fold(Left.new, (todo) async {
        final updatedTodo = todo.copyWith(
          isCompleted: !todo.isCompleted,
          updatedAt: DateTime.now(),
        );
        return updateTodo(updatedTodo);
      });
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getCompletedTodos() async {
    final todosResult = await getTodos();
    return todosResult.fold(
      Left.new,
      (todos) => Right(todos.where((todo) => todo.isCompleted).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Todo>>> getPendingTodos() async {
    final todosResult = await getTodos();
    return todosResult.fold(
      Left.new,
      (todos) => Right(todos.where((todo) => !todo.isCompleted).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Todo>>> searchTodos(String query) async {
    final todosResult = await getTodos();
    return todosResult.fold(Left.new, (todos) {
      final filteredTodos = todos
          .where(
            (todo) =>
                todo.title.toLowerCase().contains(query.toLowerCase()) ||
                todo.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      return Right(filteredTodos);
    });
  }
}
