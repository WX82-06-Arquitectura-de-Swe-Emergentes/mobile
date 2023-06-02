import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/trips/trip_screen.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text("Token: ${jsonDecode(authProvider.token ?? "")['token']}",
            //     style: TextStyle(fontSize: 10, color: Colors.black)),
            Text(
              "Test",
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const TripScreen()),
                  // );
                },
                child: Text("trips"))
          ],
        ),
      ),
    );
  }
}
