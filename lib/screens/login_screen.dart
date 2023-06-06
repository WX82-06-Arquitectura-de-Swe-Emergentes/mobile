import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/trips/trip_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  Map<String, List<dynamic>> _formErrors = {};

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _formErrors = {};
    });

    final auth = Provider.of<AuthenticationProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // ignore: use_build_context_synchronously
      await auth.signIn(email, password);
      // Navigator.of(context).pushReplacementNamed('/trip');
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripScreen(auth: auth)),
      );
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
      backgroundColor: Globals.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                children: const [
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Image(image: AssetImage('images/logo.png')),
                  ),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Please login to continue',
                    style: TextStyle(
                      fontSize: 16.0,
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
              ),
            ),
            if (_formErrors.containsKey('email'))
              ..._formErrors['email']!
                  .map((error) => Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ))
                  .toList(),
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login to your account'),
            ),
            const SizedBox(height: 16.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Dont' have an account? ",
                style: const TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Lógica del enlace aquí
                        Navigator.of(context).pushNamed('/signup');
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
