import 'package:flutter/foundation.dart';
import 'package:frontend/identity_access_management/application/identity_access_management_facade_service.dart';
import 'package:frontend/identity_access_management/domain/entities/authority.dart';
import 'package:frontend/identity_access_management/domain/entities/user.dart';
import 'package:frontend/identity_access_management/domain/enums/role.dart';
import 'package:frontend/identity_access_management/infrastructure/models/token_model.dart';
import 'package:frontend/injections.dart';

class IdentityAccessManagementApi extends ChangeNotifier {
  final IdentityAccessManagementFacadeService identityAccessManagementFacade =
      serviceLocator<IdentityAccessManagementFacadeService>();

  String _token = "";
  String _username = "";
  Role? _role;

  String get token => _token;
  String get username => _username;
  Role? get role => _role;

  bool isAgency() {
    return _role == Role.AGENCY;
  }

  bool isTraveler() {
    return _role == Role.TRAVELER;
  }

  void signOut() {
    _token = "";
    notifyListeners();
  }

  Future<TokenModel> signIn(String email, String password) async {
    final TokenModel tokenModel =
        await identityAccessManagementFacade.signIn(email, password);
    final User userModel =
        await identityAccessManagementFacade.getUser(tokenModel.token);
    final List<Authority> authorities = userModel.authorities;

    _token = tokenModel.token;
    _username = userModel.username;
    _role = authorities[0].name;

    notifyListeners();
    return tokenModel;
  }

  Future<User> signUp(String email, String password) async {
    final User user =
        await identityAccessManagementFacade.signUp(email, password);

    notifyListeners();
    return user;
  }

  Future<User> updateUser(String email, String mobileToken) async {
    final User user = await identityAccessManagementFacade.updateUser(
        _token, email, mobileToken);

    notifyListeners();
    return user;
  }
}
