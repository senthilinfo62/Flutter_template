import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing up with email and password
class SignUpWithEmail {
  SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, AuthToken>> call(SignUpWithEmailParams params) async =>
      _repository.signUpWithEmailAndPassword(
        email: params.email,
        password: params.password,
        name: params.name,
      );
}

/// Parameters for signing up with email
class SignUpWithEmailParams extends Equatable {
  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password, name];
}
