import 'dart:convert';

import 'package:frontend/common/exceptions/server_exceptions.dart';
import 'package:frontend/identity_access_management/domain/entities/user.dart';
import 'package:frontend/identity_access_management/domain/interfaces/user_interface.dart';
import 'package:frontend/identity_access_management/infrastructure/data_sources/user_remote_provider.dart';
import 'package:frontend/identity_access_management/infrastructure/models/token_model.dart';
import 'package:frontend/identity_access_management/infrastructure/models/user_model.dart';
import 'package:http/http.dart';

class UserRepository implements UserInterface {
  UserRepository({
    // required this.connectivity,
    required this.userRemoteDataProvider,
  });

  // final Connectivity connectivity;
  final UserRemoteDataProvider userRemoteDataProvider;

  void _handleSignInResponseErrors(Response response) {
    if (response.statusCode == 400) {
      final jsonBody = jsonDecode(response.body);
      final errors = jsonBody['errors'];
      final emailErrors = errors['email'] as List<dynamic>;
      final passwordErrors = errors['password'] as List<dynamic>;

      final emailErrorText =
          emailErrors.isNotEmpty ? emailErrors[0].toString() : null;
      final passwordErrorText =
          passwordErrors.isNotEmpty ? passwordErrors[0].toString() : null;

      final validationErrors = {
        'email': emailErrorText != null ? [emailErrorText] : [],
        'password': passwordErrorText != null ? [passwordErrorText] : [],
      };

      throw ApiException(errors: validationErrors);
    } else if (response.statusCode == 401) {
      const errorMessage = 'Invalid credentials';
      throw const ApiException(message: errorMessage);
    } else if (response.statusCode != 200) {
      // If the response is an unknown error, show a generic error message
      const errorMessage = 'An unknown error occurred';
      throw const ApiException(message: errorMessage);
    }
  }

  void _handleSignUpResponseErrors(Response response) {
    // Si la respuesta es un error de validación, mostrar los errores en los campos correspondientes
    if (response.statusCode == 400 && response.body.contains('errors')) {
      final jsonBody = jsonDecode(response.body);
      final errors = jsonBody['errors'];
      final emailErrors = errors['email'] as List<dynamic>;
      final passwordErrors = errors['password'] as List<dynamic>;

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

  @override
  Future<TokenModel> signIn(String email, String password) async {
    try {
      final Response response = await userRemoteDataProvider.signIn(
        email,
        password,
      );

      _handleSignInResponseErrors(response);

      final token = TokenModel.fromJson(jsonDecode(response.body));
      return token;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signUp(String email, String password) async {
    try {
      final Response response = await userRemoteDataProvider.signUp(
        email,
        password,
      );

      _handleSignUpResponseErrors(response);

      final User user = UserModel.fromJson(jsonDecode(response.body));
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUser(String token) async {
    try {
      final Response response = await userRemoteDataProvider.getUser(
        token,
      );

      final User user = UserModel.fromJson(jsonDecode(response.body));
      return user;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<User> updateUser(
      String? token, String email, String mobileToken) async {
    try {
      final Response response = await userRemoteDataProvider.updateUser(
        token,
        email,
        mobileToken,
      );

      final User user = UserModel.fromJson(jsonDecode(response.body));
      return user;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
