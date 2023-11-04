import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/common/widgets/app_bar.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/travel_experience_design_maintenance/filter_screen.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/travel_experience_design_maintenance/trip_list_screen.dart';
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
    final iamProvider = Provider.of<IdentityAccessManagementApi>(context);

    String welcomeMessage() {
      if (iamProvider.isAgency()) {
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
                        token: iamProvider.token,
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
