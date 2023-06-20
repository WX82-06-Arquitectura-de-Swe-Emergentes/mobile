import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/account_setting_screen.dart';
import 'package:frontend/screens/profile/privacyPolicy_screen.dart';
import 'package:frontend/screens/profile/notification_screen.dart';
import 'package:frontend/screens/profile/support_screen.dart';
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Card(
                        color: Color.fromARGB(255, 16, 20, 30),
                        margin: EdgeInsets.only(top: 20),
                        child: ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Account settings',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSettingScreen()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: const Card(
                        color: Color.fromARGB(255, 16, 20, 30),
                        child: ListTile(
                          leading: Icon(
                            Icons.gpp_good_outlined,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Privacy Policy',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PrivacyPolicyScreen()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: const Card(
                        color: Color.fromARGB(255, 16, 20, 30),
                        child: ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Notification',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationScreen()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: const Card(
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SupportScreen()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: const Card(
                        color: Color.fromARGB(255, 16, 20, 30),
                        child: ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            //painter: HeaderCurvedContainer(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ],
      ),
    );
  }
}
