import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/todo.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

/// Task model for data layer
@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  /// Create model from entity
  factory TodoModel.fromEntity(Todo todo) => TodoModel(
    id: todo.id,
    title: todo.title,
    description: todo.description,
    isCompleted: todo.isCompleted,
    createdAt: todo.createdAt,
    updatedAt: todo.updatedAt,
  );
}

/// Extension to add methods to TodoModel
extension TodoModelExtension on TodoModel {
  /// Convert model to entity
  Todo toEntity() => Todo(
    id: id,
    title: title,
    description: description,
    isCompleted: isCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
