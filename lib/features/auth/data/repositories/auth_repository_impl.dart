// Package imports:
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

// Project imports:
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.localDataSource, required this.dioClient})
    : remoteDataSource = AuthRemoteDataSourceImpl(dioClient);

  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final Dio dioClient;

  @override
  Future<Either<Failure, AuthToken>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final tokenModel = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store token locally
      await localDataSource.storeAuthToken(tokenModel);

      // Get and store user data
      final userModel = await remoteDataSource.getCurrentUser(
        tokenModel.accessToken,
      );
      await localDataSource.storeUser(userModel);

      return Right(tokenModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final tokenModel = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      // Store token locally
      await localDataSource.storeAuthToken(tokenModel);

      // Get and store user data
      final userModel = await remoteDataSource.getCurrentUser(
        tokenModel.accessToken,
      );
      await localDataSource.storeUser(userModel);

      return Right(tokenModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> signInWithGoogle() async {
    try {
      // TODO(username): Implement Google Sign-In
      // This would integrate with google_sign_in package
      throw UnimplementedError('Google Sign-In not implemented yet');
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> signInWithApple() async {
    try {
      // TODO(username): Implement Apple Sign-In
      // This would integrate with sign_in_with_apple package
      throw UnimplementedError('Apple Sign-In not implemented yet');
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      if (token != null) {
        try {
          await remoteDataSource.signOut(token.accessToken);
        } on Exception {
          // Continue with local sign out even if remote fails
        }
      }

      // Clear local data
      await localDataSource.clearStoredAuthToken();
      await localDataSource.clearStoredUser();

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken) async {
    try {
      final tokenModel = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.storeAuthToken(tokenModel);
      return Right(tokenModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get from local storage first
      final localUser = await localDataSource.getStoredUser();
      if (localUser != null) {
        return Right(localUser.toEntity());
      }

      // If not found locally, get from remote
      final token = await localDataSource.getStoredAuthToken();
      if (token == null) {
        return const Left(
          AuthFailure(message: 'No authentication token found'),
        );
      }

      final userModel = await remoteDataSource.getCurrentUser(
        token.accessToken,
      );
      await localDataSource.storeUser(userModel);

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? avatar,
  }) async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      if (token == null) {
        return const Left(
          AuthFailure(message: 'No authentication token found'),
        );
      }

      final userModel = await remoteDataSource.updateUserProfile(
        accessToken: token.accessToken,
        name: name,
        phoneNumber: phoneNumber,
        avatar: avatar,
      );

      await localDataSource.storeUser(userModel);
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      if (token == null) {
        return const Left(
          AuthFailure(message: 'No authentication token found'),
        );
      }

      await remoteDataSource.changePassword(
        accessToken: token.accessToken,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String verificationCode) async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      if (token == null) {
        return const Left(
          AuthFailure(message: 'No authentication token found'),
        );
      }

      await remoteDataSource.verifyEmail(
        accessToken: token.accessToken,
        verificationCode: verificationCode,
      );

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmailVerification() async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      if (token == null) {
        return const Left(
          AuthFailure(message: 'No authentication token found'),
        );
      }

      await remoteDataSource.resendEmailVerification(token.accessToken);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      if (token == null) {
        return const Left(
          AuthFailure(message: 'No authentication token found'),
        );
      }

      await remoteDataSource.deleteAccount(
        accessToken: token.accessToken,
        password: password,
      );

      // Clear local data
      await localDataSource.clearStoredAuthToken();
      await localDataSource.clearStoredUser();

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await localDataSource.getStoredAuthToken();
      return token != null && !token.toEntity().isExpired;
    } on Exception {
      return false;
    }
  }

  @override
  Future<AuthToken?> getStoredAuthToken() async {
    try {
      final tokenModel = await localDataSource.getStoredAuthToken();
      return tokenModel?.toEntity();
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> storeAuthToken(AuthToken token) async {
    final tokenModel = AuthTokenModel.fromEntity(token);
    await localDataSource.storeAuthToken(tokenModel);
  }

  @override
  Future<void> clearStoredAuthToken() async {
    await localDataSource.clearStoredAuthToken();
  }
}
