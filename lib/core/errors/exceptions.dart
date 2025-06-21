/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException: $message';
}

/// Server-related exceptions
class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

/// Cache-related exceptions
class CacheException extends AppException {
  CacheException({required super.message, super.statusCode});

  @override
  String toString() => 'CacheException: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({required super.message, super.statusCode});

  @override
  String toString() => 'NetworkException: $message';
}

/// Validation-related exceptions
class ValidationException extends AppException {
  ValidationException({required super.message, super.statusCode});

  @override
  String toString() => 'ValidationException: $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  AuthException({required super.message, super.statusCode});

  @override
  String toString() => 'AuthException: $message';
}

/// Permission-related exceptions
class PermissionException extends AppException {
  PermissionException({required super.message, super.statusCode});

  @override
  String toString() => 'PermissionException: $message';
}
