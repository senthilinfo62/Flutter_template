import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with email and password
class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, AuthToken>> call(SignInWithEmailParams params) =>
      _repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
}

/// Parameters for signing in with email
class SignInWithEmailParams extends Equatable {
  const SignInWithEmailParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
