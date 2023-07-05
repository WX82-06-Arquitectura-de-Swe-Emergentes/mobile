import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/globals.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';

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
  bool _obscurePassword = true;
  bool _termsAccepted = false;
  String _role = "Traveler";
  Map<String, List<dynamic>> _formErrors = {};

  void _handleRegister() async {
    setState(() {
      _isLoading = true;
      _formErrors = {};
    });

    final auth = Provider.of<AuthenticationProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await auth.signUp(email, password, _role.toUpperCase());

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
            MediaQuery.of(context).size.width < 400 ? 32.0 : 64.0,
            0.0,
            MediaQuery.of(context).size.width < 400 ? 32.0 : 64.0,
            32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).size.width < 400 ? 16.0 : 32.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 90.0,
                    width: 90.0,
                    child: Image(image: AssetImage('images/logo.png')),
                  ),
                  Text(
                    'Sign Up as $_role',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  const Text(
                    'Create an account to continue',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Email address',
                contentPadding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width < 400 ? 10 : 20,
                  horizontal: MediaQuery.of(context).size.width < 400 ? 10 : 20,
                ),
                hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                ),
              ),
            ),
            if (_formErrors.containsKey('email'))
              ..._formErrors['email']!
                  .map((error) => Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ))
                  .toList(),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Password',
                contentPadding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width < 400 ? 10 : 20,
                  horizontal: MediaQuery.of(context).size.width < 400 ? 10 : 20,
                ),
                hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            if (_formErrors.containsKey('password'))
              ..._formErrors['password']!
                  .map((error) => Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ))
                  .toList(),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value!;
                    });
                  },
                  visualDensity: VisualDensity.compact,
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  checkColor: Colors.red,
                ),
                const Text(
                  'Acepto las políticas de privacidad y seguridad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _isLoading || !_termsAccepted ? null : _handleRegister,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('SIGN UP'),
            ),
            const SizedBox(height: 16.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign in',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Lógica del enlace aquí
                        Navigator.of(context).pushNamed('/signin');
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'I\'m a${_role == "Agency" ? "" : "n"} ',
                style: const TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: _role == "Agency" ? "Traveler" : "Agency",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          _role = _role == "Agency" ? "Traveler" : "Agency";
                        });
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
