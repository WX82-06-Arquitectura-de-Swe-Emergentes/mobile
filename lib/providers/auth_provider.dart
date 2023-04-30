import 'package:flutter/foundation.dart';
import 'package:frontend/services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  String? _token;
  final _authenticationService = AuthenticationService();

  String? get token => _token;

  Future<bool> signIn(String email, String password) async {
    try {
      final token = await _authenticationService.signIn(email, password);
      _token = token;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void signOut() {
    _token = null;
    notifyListeners();
  }
}
