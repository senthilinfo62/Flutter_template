import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

/// Abstract local data source for authentication
abstract class AuthLocalDataSource {
  Future<void> storeAuthToken(AuthTokenModel token);
  Future<AuthTokenModel?> getStoredAuthToken();
  Future<void> clearStoredAuthToken();
  Future<void> storeUser(UserModel user);
  Future<UserModel?> getStoredUser();
  Future<void> clearStoredUser();
}

/// Implementation of local data source using SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;
  static const String _authTokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  @override
  Future<void> storeAuthToken(AuthTokenModel token) async {
    try {
      final jsonString = json.encode(token.toJson());
      await _sharedPreferences.setString(_authTokenKey, jsonString);
    } on Exception {
      throw CacheException(message: 'Failed to store auth token');
    }
  }

  @override
  Future<AuthTokenModel?> getStoredAuthToken() async {
    try {
      final jsonString = _sharedPreferences.getString(_authTokenKey);
      if (jsonString == null) return null;

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return AuthTokenModel.fromJson(jsonMap);
    } on Exception {
      throw CacheException(message: 'Failed to get auth token');
    }
  }

  @override
  Future<void> clearStoredAuthToken() async {
    try {
      await _sharedPreferences.remove(_authTokenKey);
    } on Exception {
      throw CacheException(message: 'Failed to clear auth token');
    }
  }

  @override
  Future<void> storeUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      await _sharedPreferences.setString(_userKey, jsonString);
    } on Exception {
      throw CacheException(message: 'Failed to store user');
    }
  }

  @override
  Future<UserModel?> getStoredUser() async {
    try {
      final jsonString = _sharedPreferences.getString(_userKey);
      if (jsonString == null) return null;

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } on Exception {
      throw CacheException(message: 'Failed to get user');
    }
  }

  @override
  Future<void> clearStoredUser() async {
    try {
      await _sharedPreferences.remove(_userKey);
    } on Exception {
      throw CacheException(message: 'Failed to clear user');
    }
  }
}
