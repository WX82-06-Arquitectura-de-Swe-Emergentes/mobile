import 'package:frontend/identity_access_management/domain/entities/user.dart';
import 'package:frontend/identity_access_management/infrastructure/models/user_model.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required int id,
    required String comment,
    required int rating,
    required User user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          comment: comment,
          rating: rating,
          user: user,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        comment: json["comment"],
        rating: json["rating"],
        user: UserModel.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "rating": rating,
        "user": user,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
