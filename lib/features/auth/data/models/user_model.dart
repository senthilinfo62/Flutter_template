import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model for data layer
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required bool isEmailVerified,
    required DateTime createdAt,
    String? avatar,
    String? phoneNumber,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Create model from entity
  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    email: user.email,
    name: user.name,
    avatar: user.avatar,
    phoneNumber: user.phoneNumber,
    isEmailVerified: user.isEmailVerified,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  );
}

/// Extension to add methods to UserModel
extension UserModelExtension on UserModel {
  /// Convert model to entity
  User toEntity() => User(
    id: id,
    email: email,
    name: name,
    avatar: avatar,
    phoneNumber: phoneNumber,
    isEmailVerified: isEmailVerified,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
