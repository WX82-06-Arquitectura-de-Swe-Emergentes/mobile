import 'package:frontend/models/user.dart';

class Review {
  int id;
  String comment;
  int rating;
  User user;
  DateTime createdAt;
  DateTime updatedAt;

  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        comment: json["comment"],
        rating: json["rating"],
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "rating": rating,
        "user": user.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
