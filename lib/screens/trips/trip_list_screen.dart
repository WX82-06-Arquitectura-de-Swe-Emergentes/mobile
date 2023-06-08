import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/trips/trip_details.dart';
import 'package:frontend/shared/globals.dart';
import 'package:intl/intl.dart';
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
                ? const Center(child: Text('No hay viajes disponibles'))
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (ct, i) =>
                        TripCard(trip: trips[i], auth: authProvider),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemCount: trips.length,
                  ),
          );
        }
      },
    );
  }
}

class TripCard extends StatelessWidget {
  const TripCard({Key? key, required this.trip, required this.auth})
      : super(key: key);
  final Trip trip;
  final AuthenticationProvider auth;

  @override
  Widget build(BuildContext context) {
    final difference = trip.endDate.difference(trip.startDate);
    final deviceImageWidth =
        MediaQuery.of(context).size.width < 400 ? 60.0 : 100.0;
    final deviceImageHeight =
        MediaQuery.of(context).size.height < 400 ? 60.0 : 100.0;

        String formatPriceToPenTwoDecimals(double price) {
      return 'S/ ${price.toStringAsFixed(2)}';
    }

    return InkWell(
      onTap: () async {
        await Future.delayed(Duration.zero);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(trip: trip, auth: auth),
          ),
        );
      },
      child: Card(
        color: Globals.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      trip.images[0],
                      width: deviceImageWidth,
                      height: deviceImageHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text(trip.destination.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12.0)),
                    ],
                  ))
                ],
              ),
              const SizedBox(
                  height: 24,
                  child: Divider(
                    color: Colors.white10,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Rating",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          const SizedBox(width: 8.0),
                          Text('${Random().nextInt(5)}/5',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Price",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8.0),
                      Text(formatPriceToPenTwoDecimals(trip.price),
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Status",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: trip.status == 'A'
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(trip.status == 'A' ? 'Open' : 'Closed',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Date", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8.0),
                      Text(
                          '${DateFormat('dd/MM').format(trip.startDate)} - ${DateFormat('dd/MM').format(trip.endDate)}',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
