import 'user.dart';

class Session {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
  final User? user;

  const Session({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    this.user,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
