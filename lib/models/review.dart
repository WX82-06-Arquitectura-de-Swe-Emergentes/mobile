class Review {
  int id;
  String comment;
  int rating;
  User user;
  DateTime createdAt;

  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.user,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        comment: json["comment"],
        rating: json["rating"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "rating": rating,
        "user": user.toJson(),
        "created_at": createdAt.toIso8601String(),
      };
}

class User {
  int id;
  String email;
  String image;

  User({
    required this.id,
    required this.email,
    String? image,
  }) : image = image ?? '';

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "image": image,
  };
}