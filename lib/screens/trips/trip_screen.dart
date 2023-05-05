import 'package:flutter/material.dart';
import 'package:frontend/providers/trip_provider.dart';
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
  final isLoading = ValueNotifier<bool>(true);
  final TripProvider tripProvider = TripProvider();
  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        isLoading.value = false;
      });
    });
  }

  Future getData() async {
    final tripProvider = Provider.of<TripProvider>(
      context,
      listen: false,
    );
    if (tripProvider.trips.isEmpty) {
      await tripProvider.getTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final trips = tripProvider.trips;

    return Scaffold(
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            child: const Text("Filtrar"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              );
            },
          ),
          const TripListScreen(),
        ],
      ),
    );
  }
}
