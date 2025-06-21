# Flutter Clean Architecture Template - Architecture Guide

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with strict layer separation and dependency inversion. The architecture is designed to be scalable, testable, and maintainable for enterprise-level applications.

## 📐 Layer Structure

### 1. Domain Layer (Business Logic)
**Location**: `lib/features/*/domain/`

**Responsibilities**:
- Contains business entities and rules
- Defines repository contracts (interfaces)
- Implements use cases (business logic)
- Independent of external frameworks

**Components**:
- **Entities**: Core business objects (`Todo`)
- **Repositories**: Abstract contracts for data access
- **Use Cases**: Business logic implementation

### 2. Data Layer (Data Access)
**Location**: `lib/features/*/data/`

**Responsibilities**:
- Implements repository contracts from domain layer
- Handles data sources (local and remote)
- Manages data transformation and caching

**Components**:
- **Models**: Data representations with JSON serialization
- **Data Sources**: Local (SharedPreferences, Hive) and Remote (API)
- **Repository Implementations**: Concrete implementations

### 3. Presentation Layer (UI)
**Location**: `lib/features/*/presentation/`

**Responsibilities**:
- Handles user interface and user interactions
- Manages application state with Riverpod
- Coordinates between UI and business logic

**Components**:
- **Pages**: UI screens and navigation
- **Widgets**: Reusable UI components
- **Providers**: Riverpod state management

## 🔄 Dependency Flow

```
Presentation Layer
       ↓
   Domain Layer
       ↑
    Data Layer
```

- **Presentation** depends on **Domain**
- **Data** depends on **Domain**
- **Domain** is independent (no dependencies on other layers)

## 🎯 Key Principles

### 1. Dependency Inversion
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Abstractions don't depend on details

### 2. Single Responsibility
- Each class has one reason to change
- Clear separation of concerns

### 3. Open/Closed Principle
- Open for extension, closed for modification
- Use interfaces and dependency injection

### 4. Interface Segregation
- Clients shouldn't depend on interfaces they don't use
- Small, focused interfaces

## 🛠️ Implementation Details

### State Management (Riverpod)
```dart
// Provider definition
final todoListProvider = FutureProvider((ref) async {
  final getTodos = ref.watch(getTodosUseCaseProvider);
  final result = await getTodos();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (todos) => todos,
  );
});

// Usage in UI
class TodosPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    return todosAsync.when(
      data: (todos) => TodoList(todos: todos),
      loading: () => LoadingWidget(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

### Use Case Pattern
```dart
class GetTodos {
  const GetTodos(this._repository);
  final TodoRepository _repository;

  Future<Either<Failure, List<Todo>>> call() async {
    return await _repository.getTodos();
  }
}
```

### Repository Pattern
```dart
// Abstract (Domain)
abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
}

// Implementation (Data)
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    // Implementation with error handling
  }
}
```

## 📁 Folder Structure

```
lib/
├── core/                           # Shared functionality
│   ├── constants/                  # App constants
│   ├── errors/                     # Error handling
│   ├── network/                    # Network configuration
│   ├── providers/                  # Global providers
│   ├── theme/                      # Theme configuration
│   ├── utils/                      # Utilities and extensions
│   └── widgets/                    # Reusable UI components
├── features/                       # Feature modules
│   └── todos/                      # Example feature
│       ├── data/                   # Data layer
│       │   ├── datasources/        # Data sources
│       │   ├── models/             # Data models
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   ├── repositories/       # Repository abstractions
│       │   └── usecases/           # Use cases
│       └── presentation/           # Presentation layer
│           ├── pages/              # UI pages
│           ├── providers/          # Riverpod providers
│           └── widgets/            # Feature widgets
├── l10n/                          # Localization
├── shared/                        # Shared across features
│   └── providers/                 # Global providers
└── main.dart                      # App entry point
```

## 🧪 Testing Strategy

### Unit Tests
- Test use cases in isolation
- Mock dependencies using Mocktail
- Focus on business logic

### Widget Tests
- Test UI components
- Mock providers and dependencies
- Verify user interactions

### Integration Tests
- Test complete user flows
- End-to-end functionality
- Real device testing

## 🔧 Development Guidelines

### Adding New Features
1. Create feature folder in `lib/features/`
2. Implement domain layer (entities, repositories, use cases)
3. Implement data layer (models, data sources, repository)
4. Implement presentation layer (pages, widgets, providers)
5. Add tests for each layer

### Error Handling
- Use `Either<Failure, Success>` pattern
- Define specific failure types
- Handle errors at presentation layer

### State Management
- Use Riverpod providers for state
- Keep providers focused and small
- Use appropriate provider types (Provider, StateProvider, FutureProvider, etc.)

## 📚 Best Practices

1. **Keep layers independent**
2. **Use dependency injection**
3. **Write tests for business logic**
4. **Handle errors gracefully**
5. **Follow naming conventions**
6. **Document complex logic**
7. **Use code generation tools**
8. **Maintain consistent structure**

This architecture ensures scalability, maintainability, and testability for large Flutter applications.
