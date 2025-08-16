// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/errors/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, AuthToken>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, AuthToken>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with Google
  Future<Either<Failure, AuthToken>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, AuthToken>> signInWithApple();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Refresh authentication token
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Update user profile
  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? avatar,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Verify email
  Future<Either<Failure, void>> verifyEmail(String verificationCode);

  /// Resend email verification
  Future<Either<Failure, void>> resendEmailVerification();

  /// Delete account
  Future<Either<Failure, void>> deleteAccount(String password);

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored auth token
  Future<AuthToken?> getStoredAuthToken();

  /// Store auth token
  Future<void> storeAuthToken(AuthToken token);

  /// Clear stored auth token
  Future<void> clearStoredAuthToken();
}
