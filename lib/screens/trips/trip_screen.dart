import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/trips/filter_screen.dart';
import 'package:frontend/screens/trips/trip_list_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    String welcomeMessage() {
      if (authProvider.isAgency()) {
        return "MY TRAVEL PACKAGES";
      } else {
        return "TRAVEL PACKAGES";
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Globals.backgroundColor,
          bottomNavigationBar: const AppBarBack(),
          appBar: AppBar(
            backgroundColor: Globals.redColor,
            title: Text(welcomeMessage(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: Utils.responsiveValue(context, 14, 16, 400))),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterScreen(
                        token: authProvider.token,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: const TripListScreen()),
    );
  }
}
