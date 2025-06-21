import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.statusCode});
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.statusCode});
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.statusCode});
}
