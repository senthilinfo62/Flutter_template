import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/todo_model.dart';

/// Abstract local data source for todos
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> createTodo({
    required String title,
    required String description,
  });
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
  Future<void> cacheTodos(List<TodoModel> todos);
}

/// Implementation of local data source using SharedPreferences
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  TodoLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;
  static const String _todosKey = 'cached_todos';
  final Uuid _uuid = const Uuid();

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final jsonString = _sharedPreferences.getString(_todosKey);
      if (jsonString == null) return [];

      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Exception {
      throw CacheException(message: 'Failed to get todos from cache');
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    try {
      final todos = await getTodos();
      final todo = todos.firstWhere(
        (todo) => todo.id == id,
        orElse: () => throw CacheException(message: 'Todo not found'),
      );
      return todo;
    } on Exception catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to get todo from cache');
    }
  }

  @override
  Future<TodoModel> createTodo({
    required String title,
    required String description,
  }) async {
    try {
      final todos = await getTodos();
      final newTodo = TodoModel(
        id: _uuid.v4(),
        title: title,
        description: description,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      todos.add(newTodo);
      await cacheTodos(todos);
      return newTodo;
    } on Exception {
      throw CacheException(message: 'Failed to create todo');
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final todos = await getTodos();
      final index = todos.indexWhere((t) => t.id == todo.id);

      if (index == -1) {
        throw CacheException(message: 'Todo not found');
      }

      final updatedTodo = todo.copyWith(updatedAt: DateTime.now());
      todos[index] = updatedTodo;
      await cacheTodos(todos);
      return updatedTodo;
    } on Exception catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to update todo');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      final todos = await getTodos();
      todos.removeWhere((todo) => todo.id == id);
      await cacheTodos(todos);
    } on Exception {
      throw CacheException(message: 'Failed to delete todo');
    }
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    try {
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await _sharedPreferences.setString(_todosKey, jsonString);
    } on Exception {
      throw CacheException(message: 'Failed to cache todos');
    }
  }
}
