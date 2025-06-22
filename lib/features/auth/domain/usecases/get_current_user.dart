// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current user
class GetCurrentUser {
  GetCurrentUser(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, User>> call() async => _repository.getCurrentUser();
}
