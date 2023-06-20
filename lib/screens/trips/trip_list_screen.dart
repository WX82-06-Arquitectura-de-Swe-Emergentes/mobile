import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/trips/trip_card.dart';
import 'package:provider/provider.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({Key? key}) : super(key: key);

  @override
  State<TripListScreen> createState() {
    return _TripListScreenState();
  }
}

class _TripListScreenState extends State<TripListScreen> {
  final isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    getData().then((value) {
      setState(() {
        isLoading.value = false;
      });
    });
  }

  Future<void> getData() async {
    final tripProvider = Provider.of<TripProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    if (tripProvider.trips.isEmpty) {
      await tripProvider.getTrips(authProvider.token);
    }
  }

  void setStateIfMounted(f) {
    if (mounted) {
      setState(() {
        isLoading.value = f;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context, listen: true);
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final trips = tripProvider.trips;

    double responsiveValue(double min, double max, int defaultValue) {
      if (MediaQuery.of(context).size.width < defaultValue) {
        return min;
      } else {
        return max;
      }
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (ct, value, _) {
        if (value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              setStateIfMounted(true);
              await tripProvider.getTrips(authProvider.token);
              setStateIfMounted(false);
            },
            child: trips.isEmpty
                ? const Center(
                    child: Text('No hay viajes disponibles',
                        style: TextStyle(color: Colors.white)))
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(responsiveValue(8.0, 16.0, 400)),
                    itemBuilder: (ct, i) =>
                        TripCard(trip: trips[i], auth: authProvider),
                    separatorBuilder: (_, __) =>
                        SizedBox(height: responsiveValue(8.0, 16.0, 400)),
                    itemCount: trips.length,
                  ),
          );
        }
      },
    );
  }
}

