import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/create_todo.dart';
import 'todo_providers.dart';

/// Task state notifier for managing task operations
class TodoNotifier extends StateNotifier<AsyncValue<void>> {
  TodoNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  /// Create a new todo
  Future<void> createTodo({
    required String title,
    required String description,
  }) async {
    state = const AsyncValue.loading();

    final createTodo = _ref.read(createTodoUseCaseProvider);
    final params = CreateTodoParams(title: title, description: description);

    final result = await createTodo(params);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (todo) {
        state = const AsyncValue.data(null);
        // Refresh the todo list
        _ref.invalidate(todoListProvider);
      },
    );
  }

  /// Update an existing todo
  Future<void> updateTodo(Todo todo) async {
    state = const AsyncValue.loading();

    final updateTodo = _ref.read(updateTodoUseCaseProvider);
    final result = await updateTodo(todo);

    result.fold(
      (failure) => state = AsyncValue.error(
        failure.message as Object,
        StackTrace.current,
      ),
      (updatedTodo) {
        state = const AsyncValue.data(null);
        // Refresh the todo list
        _ref.invalidate(todoListProvider);
      },
    );
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    state = const AsyncValue.loading();

    final deleteTodo = _ref.read(deleteTodoUseCaseProvider);
    final result = await deleteTodo(id);

    result.fold(
      (failure) => state = AsyncValue.error(
        failure.message as Object,
        StackTrace.current,
      ),
      (_) {
        state = const AsyncValue.data(null);
        // Refresh the todo list
        _ref.invalidate(todoListProvider);
      },
    );
  }

  /// Toggle todo completion status
  Future<void> toggleTodoCompletion(String id) async {
    final toggleCompletion = _ref.read(toggleTodoCompletionUseCaseProvider);
    final result = await toggleCompletion(id);

    result.fold(
      (failure) => state = AsyncValue.error(
        failure.message as Object,
        StackTrace.current,
      ),
      (updatedTodo) {
        // Refresh the todo list
        _ref.invalidate(todoListProvider);
      },
    );
  }
}

/// Task notifier provider
final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, AsyncValue<void>>(TodoNotifier.new);
