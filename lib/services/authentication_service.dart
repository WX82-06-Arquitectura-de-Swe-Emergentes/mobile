import 'package:frontend/services/api_service.dart';

class AuthenticationService {
  Future<dynamic> signIn(String email, String password) async {
    const endpoint = '/auth/login';
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password};

    return await ApiService.post(endpoint, headers, body);
  }

  Future<dynamic> signUp(String email, String password, String role) async {
    const endpoint = '/auth/register';
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password, 'role': role};

    return await ApiService.post(endpoint, headers, body);
  }

  Future<dynamic> updateUser(String email, String mobileToken) async {
    final endpoint = '/auth/user?email=$email';
    final headers = {'Content-Type': 'application/json'};
    final body = {"mobile_token": mobileToken};

    return await ApiService.patch(endpoint, headers, body);
  }
}
