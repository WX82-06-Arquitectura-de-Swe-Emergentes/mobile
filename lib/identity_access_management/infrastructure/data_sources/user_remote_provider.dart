import 'package:frontend/common/platform/api_connectivity.dart';
import 'package:http/http.dart';

class UserRemoteDataProvider {
  Future<Response> signIn(String email, String password) async {
    const endpoint = '/auth/login';
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password};

    return await ApiConnectivity.post(endpoint, headers, body);
  }

  Future<Response> signUp(String email, String password) async {
    const endpoint = '/auth/register';
    final headers = {'Content-Type': 'application/json'};
    final body = {'email': email, 'password': password};

    return await ApiConnectivity.post(endpoint, headers, body);
  }

  Future<Response> getUser(String token) async {
    const endpoint = '/auth/user/me';
    final headers = {'Authorization': 'Bearer $token'};

    return await ApiConnectivity.get(endpoint, headers);
  }

  Future<Response> updateUser(
      String? token, String email, String mobileToken) async {
    final endpoint = '/auth/user?email=$email';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = {"mobile_token": mobileToken};

    return await ApiConnectivity.patch(endpoint, headers, body);
  }
}
