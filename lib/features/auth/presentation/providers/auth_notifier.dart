import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import 'auth_providers.dart';
import 'auth_state.dart';

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(const AuthInitial()) {
    _checkAuthStatus();
  }

  final Ref _ref;

  /// Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();

    final repository = _ref.read(authRepositoryProvider);
    final isAuthenticated = await repository.isAuthenticated();

    if (isAuthenticated) {
      final getCurrentUser = _ref.read(getCurrentUserUseCaseProvider);
      final result = await getCurrentUser();

      result.fold(
        (failure) => state = const Unauthenticated(),
        (user) => state = Authenticated(user),
      );
    } else {
      state = const Unauthenticated();
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final signInWithEmail = _ref.read(signInWithEmailUseCaseProvider);
    final params = SignInWithEmailParams(email: email, password: password);

    final result = await signInWithEmail(params);

    await result.fold(
      (failure) async {
        state = AuthError(failure.message);
      },
      (token) async {
        // Get user data after successful sign in
        final getCurrentUser = _ref.read(getCurrentUserUseCaseProvider);
        final userResult = await getCurrentUser();

        userResult.fold(
          (failure) => state = AuthError(failure.message),
          (user) => state = Authenticated(user),
        );
      },
    );
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthLoading();

    final signUpWithEmail = _ref.read(signUpWithEmailUseCaseProvider);
    final params = SignUpWithEmailParams(
      email: email,
      password: password,
      name: name,
    );

    final result = await signUpWithEmail(params);

    await result.fold(
      (failure) async {
        state = AuthError(failure.message);
      },
      (token) async {
        // Get user data after successful sign up
        final getCurrentUser = _ref.read(getCurrentUserUseCaseProvider);
        final userResult = await getCurrentUser();

        userResult.fold(
          (failure) => state = AuthError(failure.message),
          (user) => state = Authenticated(user),
        );
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AuthLoading();

    final signOut = _ref.read(signOutUseCaseProvider);
    final result = await signOut();

    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const Unauthenticated(),
    );
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatar,
  }) async {
    if (state is! Authenticated) return;

    state = const AuthLoading();

    final repository = _ref.read(authRepositoryProvider);
    final result = await repository.updateUserProfile(
      name: name,
      phoneNumber: phoneNumber,
      avatar: avatar,
    );

    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = Authenticated(user),
    );
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      state = const Unauthenticated();
    }
  }

  /// Refresh authentication state
  Future<void> refresh() async {
    await _checkAuthStatus();
  }
}
