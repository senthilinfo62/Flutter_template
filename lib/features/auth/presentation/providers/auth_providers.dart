// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../shared/providers/dio_client_provider.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

/// Local data source provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences);
});

/// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  final dioClient = ref.watch(dioClientProvider);

  return AuthRepositoryImpl(
    localDataSource: localDataSource,
    dioClient: dioClient,
  );
});

/// Use cases providers
final signInWithEmailUseCaseProvider = Provider<SignInWithEmail>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithEmail(repository);
});

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmail>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpWithEmail(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOut(repository);
});

/// Authentication state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Current user provider
final currentUserProvider = FutureProvider((ref) async {
  final getCurrentUser = ref.watch(getCurrentUserUseCaseProvider);
  final authState = ref.watch(authStateProvider);

  if (authState is! Authenticated) {
    throw Exception('User not authenticated');
  }

  final result = await getCurrentUser();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
});

/// Authentication status provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is Authenticated;
});
