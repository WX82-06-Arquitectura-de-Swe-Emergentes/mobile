class Review{
  int id;
  String comment;
  int rating;
  User user;

  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.user,
  });

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
  };
}

class User {
  int id;
  String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
  };
}