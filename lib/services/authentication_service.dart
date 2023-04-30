import 'dart:convert';

import 'package:frontend/shared/globals.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  Future<String> signIn(String email, String password) async {
    const url = '${Globals.baseApiUrl}/auth/login';
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      // El signIn fue exitoso, devolvemos el token de sesión
      return response.body;
    } else {
      // El signIn falló, lanzamos una excepción
      throw Exception('Error en signIn Service: ${response.statusCode}');
    }
  }
}
