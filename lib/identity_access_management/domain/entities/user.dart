import 'package:frontend/identity_access_management/domain/entities/authority.dart';

class User {
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.mobileToken,
    required this.authorities,
  });

  final int id;
  final String email;
  final String username;
  final String? mobileToken;
  final List<Authority> authorities;
}
