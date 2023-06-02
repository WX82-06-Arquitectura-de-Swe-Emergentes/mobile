import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/trips/filter_screen.dart';
import 'package:frontend/screens/trips/trip_list_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/app_bar.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({Key? key,required this.auth}) : super(key: key);
  final AuthenticationProvider auth;

  @override
  // ignore: library_private_types_in_public_api
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(
        title: const Text("Trips"),
        backgroundColor: Globals.redColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            child: const Text("Filtrar"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilterScreen(token: widget.auth.token)),
              );
            },
          ),
          TripListScreen(auth: widget.auth),
        ],
      ),
    );
  }
}
