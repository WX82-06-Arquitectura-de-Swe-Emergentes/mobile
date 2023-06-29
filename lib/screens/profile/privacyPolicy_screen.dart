import 'package:flutter/material.dart';
import 'package:frontend/shared/globals.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Globals.redColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'images/privacy.png',
                  width: 350,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Queremos informarte del tipo de datos que recogemos cuando utilizas nuestros servicios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'La información que AventureHub recoge y cómo se utiliza depende del uso que hagas de sus servicios y de cómo administres los controles de privacidad. AventureHub recoge información para proporcionar los mejores servicios a todos sus usuarios, desde determinar información básica como el idioma que hablas hasta datos más complejos como los anuncios o contenido que te resultarán más útiles o relevantes.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Política de Seguridad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'images/security.png',
                  width: 350,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const FAQItem(
              question:
                  '¿Qué información se recopila cuando utilizo los servicios de AventureHub?',
              answer:
                  'La información que AventureHub recoge depende del uso que hagas de sus servicios y de cómo administres los controles de privacidad. Puede incluir información básica como el idioma que hablas, así como datos más complejos como los anuncios o contenido que te resultarán más útiles o relevantes.',
            ),
            const FAQItem(
              question:
                  '¿Qué sucede si no he iniciado sesión en una cuenta de AventureHub?',
              answer:
                  'Si no has iniciado sesión, la información recopilada se almacenará con identificadores únicos vinculados al navegador, la aplicación o el dispositivo que estés utilizando. Esto permite mantener tus preferencias en todas las sesiones de navegación, como tu idioma preferido o la personalización de los resultados de búsqueda o anuncios basados en tu actividad.',
            ),
            const FAQItem(
              question:
                  '¿Qué sucede si he iniciado sesión en una cuenta de AventureHub?',
              answer:
                  'Si has iniciado sesión, se recogerá información adicional que se almacenará en tu cuenta y será tratada como información personal. Es importante revisar y administrar adecuadamente la configuración de privacidad y los controles de AventureHub para ajustar la recopilación y el uso de tu información a tus preferencias.',
            ),
            const FAQItem(
              question:
                  '¿Qué información personal se recopila al crear una cuenta en AventureHub?',
              answer:
                  'Al crear una cuenta en AventureHub, proporcionas información personal como tu nombre y una contraseña. También puedes añadir un número de teléfono o datos de pago a tu cuenta. Aunque no hayas iniciado sesión, también puedes proporcionarnos información, como una dirección de correo electrónico para comunicarte con AventureHub o recibir novedades sobre nuestros servicios.',
            ),
            const FAQItem(
              question:
                  '¿Qué tipo de contenido se recopila cuando utilizo los servicios de AventureHub?',
              answer:
                  'Recogemos el contenido que creas, subes o recibes de otros usuarios cuando utilizas nuestros servicios. Esto incluye correos electrónicos, fotos, vídeos, documentos, hojas de cálculo y comentarios que publicas en las diferentes funciones y secciones de AventureHub.',
            ),
          ],
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
    return ExpansionTile(
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
    );
  }
}
