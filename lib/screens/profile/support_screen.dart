import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/shared/globals.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _problemController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  void _sendForm() {
    String question = _questionController.text;
    String problem = _problemController.text;

    if (question.isEmpty || problem.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Por favor, completa todos los campos antes de enviar el formulario.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formulario enviado'),
        content: const Text(
            'Gracias por contactarnos. Hemos recibido tu pregunta y la revisaremos pronto.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Necesitas ayuda?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Si tienes alguna pregunta o necesitas asistencia, no dudes en contactarnos. Estamos aquí para ayudarte en tu experiencia de viaje.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pregunta:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu pregunta',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Problema y solución intentada:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _problemController,
                decoration: const InputDecoration(
                  hintText: 'Explica el problema y lo que has intentado',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
