// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/common/exceptions/server_exceptions.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/common/widgets/responsive_spacer.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/identity_access_management/presentation/widgets/custom_checkbox.dart';
import 'package:frontend/identity_access_management/presentation/widgets/email_input.dart';
import 'package:frontend/identity_access_management/presentation/widgets/logo_section.dart';
import 'package:frontend/identity_access_management/presentation/widgets/password_input.dart';
import 'package:frontend/identity_access_management/presentation/widgets/text_rich_link.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _termsAccepted = false;
  Map<String, List<dynamic>> _formErrors = {};

  void _handleRegister() async {
    setState(() {
      _isLoading = true;
      _formErrors = {};
    });

    final iam =
        Provider.of<IdentityAccessManagementApi>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await iam.signUp(email, password);

      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed('/login');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: 'Sign Up', subtitle: 'Create an account to continue'),
            EmailInput(controller: _emailController, formErrors: _formErrors),
            const ResponsiveSpacer(minHeight: 6, maxHeight: 12, width: 400),
            PasswordInput(
                controller: _passwordController, formErrors: _formErrors),
            const ResponsiveSpacer(minHeight: 2.5, maxHeight: 5, width: 400),
            CustomCheckbox(
                label: 'Acepto los términos y condiciones',
                initialValue: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value;
                  });
                }),
            ElevatedButton(
              onPressed:
                  _isLoading || !_termsAccepted ? () => {} : _handleRegister,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return _termsAccepted ? Globals.redColor : Colors.grey;
                  },
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('SIGN UP'),
            ),
            const ResponsiveSpacer(minHeight: 16, maxHeight: 32, width: 400),
            const TextRichLink(
                linkText: "Already have an account? ",
                actionText: 'Sign in',
                route: '/signin'),
          ],
        ),
      ),
    );
  }
}
