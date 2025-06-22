// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture_template/features/todos/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_architecture_template/features/todos/domain/usecases/get_todos.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodos useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodos(mockRepository);
  });

  group('GetTodos', () {
    final tTodos = [
      Todo(
        id: '1',
        title: 'Test Todo 1',
        description: 'Test Description 1',
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
      Todo(
        id: '2',
        title: 'Test Todo 2',
        description: 'Test Description 2',
        isCompleted: true,
        createdAt: DateTime.now(),
      ),
    ];

    test('should get todos from the repository', () async {
      // Arrange
      when(
        () => mockRepository.getTodos(),
      ).thenAnswer((_) async => Right(tTodos));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, List<Todo>>(tTodos));
      verify(() => mockRepository.getTodos()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure(message: 'Server error');
      when(
        () => mockRepository.getTodos(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left<Failure, List<Todo>>(tFailure));
      verify(() => mockRepository.getTodos()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
