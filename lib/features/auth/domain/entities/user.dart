// Package imports:
import 'package:equatable/equatable.dart';

/// User entity representing a user in the domain layer
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.isEmailVerified,
    required this.createdAt,
    this.avatar,
    this.phoneNumber,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phoneNumber;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Create a copy of this user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phoneNumber,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatar,
    phoneNumber,
    isEmailVerified,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() =>
      'User(id: $id, email: $email, name: $name, '
      'isEmailVerified: $isEmailVerified)';
}
