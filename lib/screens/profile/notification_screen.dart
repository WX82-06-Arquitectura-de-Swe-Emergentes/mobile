import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _receiveEmails = true;
  bool _receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Notifications promotional'),
            subtitle: const Text('Receive promotional'),
            trailing: Switch(
              value: _receiveEmails,
              onChanged: (value) {
                setState(() {
                  _receiveEmails = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications offers'),
            subtitle: const Text('Receive offers'),
            trailing: Switch(
              value: _receiveNotifications,
              onChanged: (value) {
                setState(() {
                  _receiveNotifications = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement save settings functionality
            },
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
