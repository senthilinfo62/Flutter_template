import 'package:equatable/equatable.dart';

/// Authentication token entity
class AuthToken extends Equatable {
  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.issuedAt,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn; // seconds
  final DateTime issuedAt;

  /// Check if token is expired
  bool get isExpired {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expiryTime);
  }

  /// Check if token will expire soon (within 5 minutes)
  bool get willExpireSoon {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiryTime);
  }

  /// Get authorization header value
  String get authorizationHeader => '$tokenType $accessToken';

  @override
  List<Object> get props => [
    accessToken,
    refreshToken,
    tokenType,
    expiresIn,
    issuedAt,
  ];

  @override
  String toString() =>
      'AuthToken(tokenType: $tokenType, expiresIn: $expiresIn, '
      'issuedAt: $issuedAt, isExpired: $isExpired)';
}
