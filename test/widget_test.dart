import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_clean_architecture_template/core/providers/shared_preferences_provider.dart';
import 'package:flutter_clean_architecture_template/features/todos/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_clean_architecture_template/features/todos/data/models/todo_model.dart';
import 'package:flutter_clean_architecture_template/features/todos/presentation/providers/todo_providers.dart';
import 'package:flutter_clean_architecture_template/main.dart';
import 'package:flutter_clean_architecture_template/shared/providers/dio_client_provider.dart';

// Mock classes
class MockDio extends Mock implements Dio {}

class MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

void main() {
  group('App Widget Tests', () {
    late SharedPreferences sharedPreferences;
    late MockDio mockDio;
    late MockTodoRemoteDataSource mockTodoRemoteDataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      mockDio = MockDio();
      mockTodoRemoteDataSource = MockTodoRemoteDataSource();

      // Setup mock responses
      when(() => mockTodoRemoteDataSource.getTodos()).thenAnswer(
        (_) async => [
          TodoModel(
            id: '1',
            title: 'Test Todo',
            description: 'Test Description',
            isCompleted: false,
            createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
            updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
          ),
        ],
      );
    });

    testWidgets('App should build without errors', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            dioClientProvider.overrideWithValue(mockDio),
            todoRemoteDataSourceProvider.overrideWithValue(
              mockTodoRemoteDataSource,
            ),
          ],
          child: const MyApp(),
        ),
      );

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should show main navigation structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            dioClientProvider.overrideWithValue(mockDio),
            todoRemoteDataSourceProvider.overrideWithValue(
              mockTodoRemoteDataSource,
            ),
          ],
          child: const MyApp(),
        ),
      );

      // Wait for initial build
      await tester.pump();

      // Wait for async operations to complete with timeout
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the app navigation is working
      expect(find.byType(MaterialApp), findsOneWidget);

      // Check for basic app structure - should have some navigation
      // The exact navigation structure depends on the implementation
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('App should handle network errors gracefully', (tester) async {
      // Setup error response
      when(() => mockTodoRemoteDataSource.getTodos()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/todos'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            dioClientProvider.overrideWithValue(mockDio),
            todoRemoteDataSourceProvider.overrideWithValue(
              mockTodoRemoteDataSource,
            ),
          ],
          child: const MyApp(),
        ),
      );

      // Wait for initial build
      await tester.pump();

      // Wait for error handling
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the app handles errors gracefully
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
