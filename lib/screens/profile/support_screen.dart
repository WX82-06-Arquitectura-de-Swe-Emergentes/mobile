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
      backgroundColor: Globals.backgroundColor,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Necesitas ayuda?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Si tienes alguna pregunta o necesitas asistencia, no dudes en contactarnos. Estamos aquí para ayudarte en tu experiencia de viaje.',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pregunta:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu pregunta',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Problema y solución intentada:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _problemController,
                decoration: const InputDecoration(
                  hintText: 'Explica el problema y lo que has intentado',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendForm,
                child: const Text('Enviar'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Preguntas frecuentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const FAQItem(
                question: '¿Cómo puedo reservar un vuelo?',
                answer:
                    'Para reservar un vuelo, debes seguir los siguientes pasos:\n\n1. Ingresa en nuestra aplicación y selecciona la opción de "Reservar vuelo".\n\n2. Selecciona tu origen y destino, así como las fechas de ida y regreso.\n\n3. Escoge la aerolínea y el horario que mejor se adapten a tus necesidades.\n\n4. Proporciona los datos personales de los pasajeros y realiza el pago.\n\n¡Listo! Tu vuelo ha sido reservado correctamente.',
              ),
              const FAQItem(
                question: '¿Puedo cancelar o modificar mi reserva?',
                answer:
                    'Sí, puedes cancelar o modificar tu reserva siguiendo estos pasos:\n\n1. Accede a tu cuenta en nuestra aplicación y busca la sección de "Mis reservas".\n\n2. Encuentra la reserva que deseas cancelar o modificar y selecciona la opción correspondiente.\n\n3. Sigue las instrucciones proporcionadas para completar la cancelación o modificación.\n\nRecuerda que pueden aplicar políticas de cancelación o cambios según las condiciones de la aerolínea.',
              ),
              const FAQItem(
                question: '¿Cómo puedo contactar al servicio al cliente?',
                answer:
                    'Para contactar a nuestro servicio al cliente, puedes hacer lo siguiente:\n\n1. Envíanos un correo electrónico a AdventureHub@gmail.com.\n\n2. Llama a nuestro número de atención al cliente +1-123-456-7890.\n\n3. Utiliza el formulario de contacto en nuestra aplicación y describe tu consulta o problema.\n\nEstaremos encantados de ayudarte en lo que necesites.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.red,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
