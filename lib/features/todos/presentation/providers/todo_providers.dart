import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../shared/providers/dio_client_provider.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../data/datasources/todo_remote_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo_completion.dart';
import '../../domain/usecases/update_todo.dart';

/// Local data source provider
final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TodoLocalDataSourceImpl(sharedPreferences);
});

/// Remote data source provider
final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TodoRemoteDataSourceImpl(dioClient);
});

/// Repository provider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final localDataSource = ref.watch(todoLocalDataSourceProvider);
  final remoteDataSource = ref.watch(todoRemoteDataSourceProvider);

  return TodoRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Use cases providers
final getTodosUseCaseProvider = Provider<GetTodos>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodos(repository);
});

final createTodoUseCaseProvider = Provider<CreateTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return CreateTodo(repository);
});

final updateTodoUseCaseProvider = Provider<UpdateTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return UpdateTodo(repository);
});

final deleteTodoUseCaseProvider = Provider<DeleteTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodo(repository);
});

final toggleTodoCompletionUseCaseProvider = Provider<ToggleTodoCompletion>((
  ref,
) {
  final repository = ref.watch(todoRepositoryProvider);
  return ToggleTodoCompletion(repository);
});

/// Task list provider
final todoListProvider = FutureProvider((ref) async {
  final getTodos = ref.watch(getTodosUseCaseProvider);
  final result = await getTodos();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (todos) => todos,
  );
});

/// Completed todos provider
final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todosAsync = ref.watch(todoListProvider);

  return todosAsync.when(
    data: (todos) => todos.where((todo) => todo.isCompleted).toList(),
    loading: () => <Todo>[],
    error: (error, stack) => <Todo>[],
  );
});

/// Pending todos provider
final pendingTodosProvider = Provider<List<Todo>>((ref) {
  final todosAsync = ref.watch(todoListProvider);

  return todosAsync.when(
    data: (todos) => todos.where((todo) => !todo.isCompleted).toList(),
    loading: () => <Todo>[],
    error: (error, stack) => <Todo>[],
  );
});

/// Task search provider
final todoSearchProvider = StateProvider<String>((ref) => '');

/// Filtered todos provider
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todosAsync = ref.watch(todoListProvider);
  final searchQuery = ref.watch(todoSearchProvider);

  return todosAsync.when(
    data: (todos) {
      if (searchQuery.isEmpty) return todos;

      return todos
          .where(
            (todo) =>
                todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                todo.description.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    },
    loading: () => <Todo>[],
    error: (error, stack) => <Todo>[],
  );
});
