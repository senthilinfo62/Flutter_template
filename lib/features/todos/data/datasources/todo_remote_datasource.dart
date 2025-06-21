import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/todo_model.dart';

/// Abstract remote data source for todos
abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> createTodo({
    required String title,
    required String description,
  });
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

/// Implementation of remote data source using API
class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  TodoRemoteDataSourceImpl(this._dioClient);

  final Dio _dioClient;

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final response = await _dioClient.get<List<dynamic>>('/todos');
      final jsonList = response.data!;
      return jsonList
          .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Exception {
      throw ServerException(message: 'Failed to fetch todos');
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('/todos/$id');
      return TodoModel.fromJson(response.data!);
    } on Exception {
      throw ServerException(message: 'Failed to fetch todo');
    }
  }

  @override
  Future<TodoModel> createTodo({
    required String title,
    required String description,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/todos',
        data: {
          'title': title,
          'description': description,
          'isCompleted': false,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
      return TodoModel.fromJson(response.data!);
    } on Exception {
      throw ServerException(message: 'Failed to create todo');
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final response = await _dioClient.put<Map<String, dynamic>>(
        '/todos/${todo.id}',
        data: todo.copyWith(updatedAt: DateTime.now()).toJson(),
      );
      return TodoModel.fromJson(response.data!);
    } on Exception {
      throw ServerException(message: 'Failed to update todo');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await _dioClient.delete<void>('/todos/$id');
    } on Exception {
      throw ServerException(message: 'Failed to delete todo');
    }
  }
}
