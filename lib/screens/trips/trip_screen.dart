import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/trips/filter_screen.dart';
import 'package:frontend/screens/trips/trip_list_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() {
    return _TripScreenState();
  }
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(
        title: const Text("Trips"),
        backgroundColor: Globals.redColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(token: authProvider.token),
                ),
              );
            },
          ),
        ],
      ),
      body: const TripListScreen(),
    );
  }
}
