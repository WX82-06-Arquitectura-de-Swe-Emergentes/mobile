import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/trips/filter_screen.dart';
import 'package:frontend/screens/trips/trip_list_screen.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final token = authProvider.token;

    return Scaffold(
      backgroundColor: const Color.fromARGB(16, 20, 30, 1),
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(
        title: const Text("Trips"),
        backgroundColor: const Color.fromRGBO(252, 71, 71, 1),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Sort By : "),
          TextButton(
            child: const Text("Filtrar"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilterScreen(token: token)),
              );
            },
          ),
          TripListScreen(token: token),
        ],
      ),
    );
  }
}
