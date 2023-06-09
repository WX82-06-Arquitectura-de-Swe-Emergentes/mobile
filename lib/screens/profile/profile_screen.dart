import 'package:flutter/material.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Globals.redColor,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                //margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Color.fromARGB(255, 16, 20, 30),
                      margin: EdgeInsets.only(top: 255),
                      child: ListTile(
                        leading: Icon(
                          Icons.gpp_good_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Seguridad y Privacidad',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Card(
                      color: Color.fromARGB(255, 16, 20, 30),
                      child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Configuración de la cuenta',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Card(
                      color: Color.fromARGB(255, 16, 20, 30),
                      child: ListTile(
                          leading: Icon(
                            Icons.help_outline_rounded,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Help & Support',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          )),
                    ),
                    Card(
                      color: Color.fromARGB(255, 16, 20, 30),
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            painter: HeaderCurvedContainer(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/profile.png'),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 270, left: 184),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color.fromARGB(255, 255, 58, 58);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
