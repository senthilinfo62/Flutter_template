// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../../../core/errors/exceptions.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

/// Abstract remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthTokenModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthTokenModel> signInWithGoogle(String googleToken);

  Future<AuthTokenModel> signInWithApple(String appleToken);

  Future<void> signOut(String accessToken);

  Future<AuthTokenModel> refreshToken(String refreshToken);

  Future<UserModel> getCurrentUser(String accessToken);

  Future<UserModel> updateUserProfile({
    required String accessToken,
    String? name,
    String? phoneNumber,
    String? avatar,
  });

  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> verifyEmail({
    required String accessToken,
    required String verificationCode,
  });

  Future<void> resendEmailVerification(String accessToken);

  Future<void> deleteAccount({
    required String accessToken,
    required String password,
  });
}

/// Implementation of remote data source using API
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dioClient);

  final Dio _dioClient;

  @override
  Future<AuthTokenModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/signin',
        data: {'email': email, 'password': password},
      );
      return AuthTokenModel.fromApiResponse(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to sign in');
    }
  }

  @override
  Future<AuthTokenModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/signup',
        data: {'email': email, 'password': password, 'name': name},
      );
      return AuthTokenModel.fromApiResponse(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to sign up');
    }
  }

  @override
  Future<AuthTokenModel> signInWithGoogle(String googleToken) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/google',
        data: {'token': googleToken},
      );
      return AuthTokenModel.fromApiResponse(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to sign in with Google');
    }
  }

  @override
  Future<AuthTokenModel> signInWithApple(String appleToken) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/apple',
        data: {'token': appleToken},
      );
      return AuthTokenModel.fromApiResponse(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to sign in with Apple');
    }
  }

  @override
  Future<void> signOut(String accessToken) async {
    try {
      await _dioClient.post<void>(
        '/auth/signout',
        options: _getAuthOptions(accessToken),
      );
    } on Exception {
      throw AuthException(message: 'Failed to sign out');
    }
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return AuthTokenModel.fromApiResponse(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to refresh token');
    }
  }

  @override
  Future<UserModel> getCurrentUser(String accessToken) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/auth/me',
        options: _getAuthOptions(accessToken),
      );
      return UserModel.fromJson(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to get current user');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    required String accessToken,
    String? name,
    String? phoneNumber,
    String? avatar,
  }) async {
    try {
      final response = await _dioClient.put<Map<String, dynamic>>(
        '/auth/profile',
        data: {
          if (name != null) 'name': name,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (avatar != null) 'avatar': avatar,
        },
        options: _getAuthOptions(accessToken),
      );
      return UserModel.fromJson(response.data!);
    } on Exception {
      throw AuthException(message: 'Failed to update profile');
    }
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dioClient.put<void>(
        '/auth/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: _getAuthOptions(accessToken),
      );
    } on Exception {
      throw AuthException(message: 'Failed to change password');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dioClient.post<void>(
        '/auth/password-reset',
        data: {'email': email},
      );
    } on Exception {
      throw AuthException(message: 'Failed to send password reset email');
    }
  }

  @override
  Future<void> verifyEmail({
    required String accessToken,
    required String verificationCode,
  }) async {
    try {
      await _dioClient.post<void>(
        '/auth/verify-email',
        data: {'verification_code': verificationCode},
        options: _getAuthOptions(accessToken),
      );
    } on Exception {
      throw AuthException(message: 'Failed to verify email');
    }
  }

  @override
  Future<void> resendEmailVerification(String accessToken) async {
    try {
      await _dioClient.post<void>(
        '/auth/resend-verification',
        options: _getAuthOptions(accessToken),
      );
    } on Exception {
      throw AuthException(message: 'Failed to resend verification email');
    }
  }

  @override
  Future<void> deleteAccount({
    required String accessToken,
    required String password,
  }) async {
    try {
      await _dioClient.delete<void>(
        '/auth/account',
        data: {'password': password},
        options: _getAuthOptions(accessToken),
      );
    } on Exception {
      throw AuthException(message: 'Failed to delete account');
    }
  }

  Options _getAuthOptions(String accessToken) =>
      Options(headers: {'Authorization': 'Bearer $accessToken'});
}
