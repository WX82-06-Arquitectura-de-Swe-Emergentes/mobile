// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/common/exceptions/server_exceptions.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/common/widgets/responsive_spacer.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/notification/fcm/firebase_cloud_messagging_service.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/identity_access_management/presentation/widgets/custom_checkbox.dart';
import 'package:frontend/identity_access_management/presentation/widgets/email_input.dart';
import 'package:frontend/identity_access_management/presentation/widgets/logo_section.dart';
import 'package:frontend/identity_access_management/presentation/widgets/password_input.dart';
import 'package:frontend/identity_access_management/presentation/widgets/text_rich_link.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences? _prefs;
  bool _isLoading = false;
  bool _rememberUser = false;
  Map<String, List<dynamic>> _formErrors = {};

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _formErrors = {};
    });

    final iam =
        Provider.of<IdentityAccessManagementApi>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await iam.signIn(email, password);

      if (FCMService.tokenValue != '') {
        await iam.updateUser(email, FCMService.tokenValue);
      }

      if (_rememberUser) {
        await savePreferences(email, password);
      } else {
        await clearPreferences();
      }

      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed('/trip');
      });
    } on ApiException catch (e) {
      if (e.message != '') {
        // Si el login falla, muestra un mensaje de error
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        );
      }

      setState(() {
        _isLoading = false;
        _formErrors = e.errors;
      });
    } catch (e) {
      // Manejar otros errores que no son de ApiException aquí
      setState(() {
        _isLoading = false;
        _formErrors = {
          'general': ['An unexpected error occurred']
        };
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> savePreferences(String email, String password) async {
    if (_prefs != null) {
      await _prefs!.setString('email', email);
      await _prefs!.setString('password', password);
    }
  }

  Future<void> clearPreferences() async {
    if (_prefs != null) {
      await _prefs!.remove('email');
      await _prefs!.remove('password');
    }
  }

  void loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      setState(() {
        _rememberUser = _prefs!.getString('email') != null &&
            _prefs!.getString('password') != null;
        if (_rememberUser) {
          _emailController.text = _prefs!.getString('email') ?? '';
          _passwordController.text = _prefs!.getString('password') ?? '';
        }
      });
    }
  }

  @override
  void initState() {
    loadPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Globals.primaryColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              Utils.responsiveValue(context, 32, 48, 400),
              0.0,
              Utils.responsiveValue(context, 32, 48, 400),
              32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const LogoSection(
                  title: 'Sign In', subtitle: 'Please login to continue'),
              EmailInput(controller: _emailController, formErrors: _formErrors),
              const ResponsiveSpacer(minHeight: 6, maxHeight: 12, width: 400),
              PasswordInput(
                  controller: _passwordController, formErrors: _formErrors),
              const ResponsiveSpacer(minHeight: 2.5, maxHeight: 5, width: 400),
              // RememberUserCheckbox(rememberUser: _rememberUser),
              CustomCheckbox(
                  label: 'Guardar mis credenciales',
                  initialValue: _rememberUser,
                  onChanged: (value) {
                    setState(() {
                      _rememberUser = value;
                    });
                  }),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _handleLogin(),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('LOGIN TO YOUR ACCOUNT'),
              ),
              const ResponsiveSpacer(minHeight: 16, maxHeight: 32, width: 400),
              const TextRichLink(
                  linkText: "Dont' have an account? ",
                  actionText: 'Sign up',
                  route: '/signup'),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
