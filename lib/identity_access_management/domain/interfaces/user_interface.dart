import 'package:frontend/identity_access_management/domain/entities/user.dart';
import 'package:frontend/identity_access_management/infrastructure/models/token_model.dart';

abstract class UserInterface {
  Future<TokenModel> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<User> getUser(String token);
  Future<User> updateUser(String? token, String email, String mobileToken);
}
