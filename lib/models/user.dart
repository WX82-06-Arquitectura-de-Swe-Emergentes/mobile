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