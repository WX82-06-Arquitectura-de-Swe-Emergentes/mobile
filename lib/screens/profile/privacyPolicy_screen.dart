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
            const SizedBox(height: 8),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'La información que AventureHub recoge y cómo se utiliza depende del uso que hagas de sus servicios y de cómo administres los controles de privacidad. AventureHub recoge información para proporcionar los mejores servicios a todos sus usuarios, desde determinar información básica como el idioma que hablas hasta datos más complejos como los anuncios o contenido que te resultarán más útiles o relevantes.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              'Si no has iniciado sesión en una cuenta de AventureHub, se almacenará la información recopilada con identificadores únicos vinculados al navegador, la aplicación o el dispositivo que estés utilizando. Esto permite mantener tus preferencias en todas las sesiones de navegación, como tu idioma preferido o la personalización de los resultados de búsqueda o anuncios basados en tu actividad.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              'Si has iniciado sesión en una cuenta de AventureHub, también se recogerá información que se almacenará en tu cuenta y será tratada como información personal. Es importante revisar y administrar adecuadamente la configuración de privacidad y los controles de AventureHub para asegurarte de que la recopilación y el uso de tu información se ajusten a tus preferencias.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Política de Seguridad',
              style: TextStyle(
                fontSize: 20,
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
            const SizedBox(height: 10),
            const Text(
              'Al crear una cuenta en AventureHub, nos proporcionas información personal que incluye tu nombre y una contraseña. También puedes añadir un número de teléfono o datos de pago a tu cuenta. Aunque no hayas iniciado sesión en una cuenta de AventureHub, también puedes proporcionarnos información, como una dirección de correo electrónico para comunicarte con AventureHub o recibir novedades sobre nuestros servicios.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              'También recogemos el contenido que creas, subes o recibes de otros usuarios cuando utilizas nuestros servicios. Entre estos datos se incluyen los correos electrónicos que escribes y recibes, las fotos y los vídeos que guardas, los documentos y las hojas de cálculo que creas, y los comentarios que publicas en las diferentes funciones y secciones de AventureHub.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
