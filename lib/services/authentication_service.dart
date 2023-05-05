import 'package:frontend/services/api_service.dart';

class AuthenticationService {
  Future<dynamic> signIn(String email, String password) async {
    const endpoint = '/auth/login';
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password};

    return await ApiService.post(endpoint, headers, body);
  }

  Future<dynamic> signUp(String email, String password) async {
    const endpoint = '/auth/register';
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password};

    return await ApiService.post(endpoint, headers, body);
  }
}
