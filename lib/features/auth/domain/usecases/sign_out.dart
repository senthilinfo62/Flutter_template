// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing out
class SignOut {
  SignOut(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, void>> call() async => _repository.signOut();
}
