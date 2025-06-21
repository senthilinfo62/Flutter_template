import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_token.dart';

part 'auth_token_model.freezed.dart';
part 'auth_token_model.g.dart';

/// Auth token model for data layer
@freezed
class AuthTokenModel with _$AuthTokenModel {
  const factory AuthTokenModel({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required DateTime issuedAt,
  }) = _AuthTokenModel;

  /// Create model from entity
  factory AuthTokenModel.fromEntity(AuthToken token) => AuthTokenModel(
    accessToken: token.accessToken,
    refreshToken: token.refreshToken,
    tokenType: token.tokenType,
    expiresIn: token.expiresIn,
    issuedAt: token.issuedAt,
  );

  /// Create from API response
  factory AuthTokenModel.fromApiResponse(Map<String, dynamic> json) =>
      AuthTokenModel(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        tokenType: json['token_type'] as String? ?? 'Bearer',
        expiresIn: json['expires_in'] as int,
        issuedAt: DateTime.now(),
      );

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);
}

/// Extension to add methods to AuthTokenModel
extension AuthTokenModelExtension on AuthTokenModel {
  /// Convert model to entity
  AuthToken toEntity() => AuthToken(
    accessToken: accessToken,
    refreshToken: refreshToken,
    tokenType: tokenType,
    expiresIn: expiresIn,
    issuedAt: issuedAt,
  );
}
