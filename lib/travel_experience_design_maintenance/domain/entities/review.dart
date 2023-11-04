import 'package:frontend/identity_access_management/domain/entities/user.dart';

class Review {
  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String comment;
  final int rating;
  final User user;
  final DateTime createdAt;
  final DateTime updatedAt;
}
