import 'package:frontend/identity_access_management/domain/entities/authority.dart';
import 'package:frontend/identity_access_management/infrastructure/models/authority_model.dart';
import 'package:frontend/identity_access_management/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String email,
    required String username,
    required String? mobileToken,
    required List<Authority> authorities,
  }) : super(
          id: id,
          email: email,
          username: username,
          mobileToken: mobileToken,
          authorities: authorities,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] as int,
        email: json["email"] as String,
        username: json["username"] as String,
        mobileToken: json["mobile_token"] as String?,
        authorities: List<AuthorityModel>.from(
            json["authorities"].map((x) => AuthorityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "mobile_token": mobileToken,
        "authorities": authorities,
      };
}
