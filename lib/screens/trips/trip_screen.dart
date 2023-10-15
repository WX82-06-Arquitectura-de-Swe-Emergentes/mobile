import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/trips/role_trip_list_screen.dart';
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

class _TripScreenState extends State<TripScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // final tripProvider = Provider.of<TripProvider>(context, listen: true);

    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      // tripProvider.resetData();
      print("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    String welcomeMessage() {
      if (authProvider.isAgency()) {
        return "Welcome ${authProvider.username}, manage your trips here.";
      } else {
        return "Welcome ${authProvider.username}, looking for a trip?";
      }
    }

    List<Widget> tabsByRole() {
      List<Widget> tabs = [];
      if (authProvider.isAgency()) {
        tabs = [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text("All Trips",
                  style: TextStyle(
                      fontSize: Utils.responsiveValue(context, 12, 14, 400)))),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text("My Trips",
                  style: TextStyle(
                      fontSize: Utils.responsiveValue(context, 12, 14, 400)))),
        ];
      } else {
        tabs = [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text("All Trips",
                  style: TextStyle(
                      fontSize: Utils.responsiveValue(context, 12, 14, 400)))),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text("Booked Trips",
                  style: TextStyle(
                      fontSize: Utils.responsiveValue(context, 12, 14, 400)))),
        ];
      }
      return tabs;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Globals.backgroundColor,
        bottomNavigationBar: const AppBarBack(),
        appBar: AppBar(
          backgroundColor: Globals.redColor,
          bottom: TabBar(
            isScrollable: true,
            controller: _controller,
            labelStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: tabsByRole(),
          ),
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
                        currentIndex: _controller.index),
                  ),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: _controller,
          children: const [TripListScreen(), RoleTripListScreen()],
        ),
      ),
    );
  }
}
