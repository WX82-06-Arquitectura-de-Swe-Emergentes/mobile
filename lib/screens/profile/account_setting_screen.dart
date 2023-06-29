import 'package:flutter/material.dart';
import 'package:frontend/firebase/notification/push_notifications_service.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/auth_provider.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({Key? key, this.token}) : super(key: key);
  final String? token;

  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final authProvider = AuthenticationProvider();
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  final TextEditingController _oldEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              '¿Está seguro de que desea eliminar su cuenta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // TODO: Implement delete account logic
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Account Deleted'),
                      content:
                          const Text('Su cuenta ha sido eliminada con éxito!'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Contraseña actual'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu contraseña actual';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Nueva contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu nueva contraseña';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirmar contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, confirma tu contraseña';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('¡Contraseña cambiada correctamente!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String oldEmail = _oldEmailController.text;
      String newEmail = _newEmailController.text;
      //String mobileToken = PushNotificationService.tokenValue;

      try {
        authProvider.updateEmail(oldEmail, newEmail);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Datos actualizados correctamente!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar los datos: $e')),
        );
      }
    }
  }

  void _recoverPassword(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Sent'),
          content: const Text(
              'Se ha enviado un correo electrónico con instrucciones para restablecer la contraseña a su dirección de correo electrónico.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _oldEmailController,
                  decoration: const InputDecoration(
                      labelText: 'Correo electrónico Actual'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico actual';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newEmailController,
                  decoration: const InputDecoration(
                      labelText: 'Nuevo correo electrónico'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa tu nuevo correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Guardar cambios'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    authProvider.updateEmail(_emailController.text,
                        PushNotificationService.tokenValue);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Password Recovery'),
                          content: const Text(
                              'Ingrese su dirección de correo electrónico para recibir un enlace de restablecimiento de contraseña.'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Recover'),
                              onPressed: () {
                                // TODO: Implement password recovery logic
                                Navigator.of(context).pop();
                                _recoverPassword(_emailController.text);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Recover Password'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    _showDeleteAccountDialog();
                  },
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
