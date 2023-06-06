import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/services/authentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  String? _token;
  String _username = "";

  String? get token => _token;
  String get username => _username;

  final _authenticationService = AuthenticationService();

  Future<dynamic> signIn(String email, String password) async {
    final response = await _authenticationService.signIn(email, password);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      _token = jsonBody["token"];
      _username = jsonBody["username"] ?? "";
      notifyListeners();
      return;
    }

    if (response.statusCode == 401) {
      const errorMessage = 'Invalid credentials';
      throw const ApiException(message: errorMessage);
    }

    // Si la respuesta es un error de validación, mostrar los errores en los campos correspondientes
    if (response.statusCode == 400) {
      final jsonBody = jsonDecode(response.body);
      final errors = jsonBody['errors'];
      final emailErrors = errors['email'] as List<dynamic> ?? [];
      final passwordErrors = errors['password'] as List<dynamic> ?? [];

      final emailErrorText =
          emailErrors.isNotEmpty ? emailErrors[0].toString() : null;
      final passwordErrorText =
          passwordErrors.isNotEmpty ? passwordErrors[0].toString() : null;

      final validationErrors = {
        'email': emailErrorText != null ? [emailErrorText] : [],
        'password': passwordErrorText != null ? [passwordErrorText] : [],
      };

      throw ApiException(errors: validationErrors);
    } else {
      // Si la respuesta es un error desconocido, mostrar un mensaje de error genérico
      const errorMessage = 'An unknown error occurred';
      throw const ApiException(message: errorMessage);
    }
  }

  Future<dynamic> signUp(String email, String password) async {
    final response = await _authenticationService.signUp(email, password);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      _token = jsonBody["token"];
      notifyListeners();
      return;
    }

    // Si la respuesta es un error de validación, mostrar los errores en los campos correspondientes
    if (response.statusCode == 400 && response.body.contains('errors')) {
      final jsonBody = jsonDecode(response.body);
      final errors = jsonBody['errors'];
      final emailErrors = errors['email'] as List<dynamic> ?? [];
      final passwordErrors = errors['password'] as List<dynamic> ?? [];

      final emailErrorText =
          emailErrors.isNotEmpty ? emailErrors[0].toString() : null;
      final passwordErrorText =
          passwordErrors.isNotEmpty ? passwordErrors[0].toString() : null;

      final validationErrors = {
        'email': emailErrorText != null ? [emailErrorText] : [],
        'password': passwordErrorText != null ? [passwordErrorText] : [],
      };

      throw ApiException(errors: validationErrors);
    } else {
      final jsonBody = jsonDecode(response.body);
      throw ApiException(message: jsonBody['message']);
    }
  }

  void signOut() {
    _token = null;
    notifyListeners();
  }
}

class ApiException implements Exception {
  final String message;
  final Map<String, List<dynamic>> errors;

  const ApiException({this.message = '', this.errors = const {}});

  @override
  String toString() => 'ApiException: $message, errors: $errors';
}
