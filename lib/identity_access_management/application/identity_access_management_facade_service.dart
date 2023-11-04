import 'package:frontend/identity_access_management/domain/entities/user.dart';
import 'package:frontend/identity_access_management/infrastructure/models/token_model.dart';
import 'package:frontend/identity_access_management/infrastructure/repositories/user_repository.dart';

class IdentityAccessManagementFacadeService  {
  IdentityAccessManagementFacadeService({
    required this.repository,
  });

  final UserRepository repository;

  Future<TokenModel> signIn(String email, String password) {
    return repository.signIn(email, password);
  }

  Future<User> signUp(String email, String password) {
    return repository.signUp(email, password);
  }

  Future<User> getUser(String token) {
    return repository.getUser(token);
  }

  Future<User> updateUser(String? token, String email, String mobileToken) {
    return repository.updateUser(token, email, mobileToken);
  }
}
