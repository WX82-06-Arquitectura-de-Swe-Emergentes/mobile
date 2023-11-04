import 'package:frontend/identity_access_management/domain/entities/authority.dart';
import 'package:frontend/identity_access_management/domain/enums/role.dart';

class AuthorityModel extends Authority {
  AuthorityModel({required int id, required Role name})
      : super(id: id, name: name);

  factory AuthorityModel.fromJson(Map<String, dynamic> json) {
    return AuthorityModel(
      id: json['id'],
      name: roleValues[json['name']]!,
    );
  }
}
