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

class TripCard extends StatelessWidget {
  const TripCard({Key? key, required this.trip, required this.auth})
      : super(key: key);
  final Trip trip;
  final AuthenticationProvider auth;

  @override
  Widget build(BuildContext context) {
    String formatPriceToPenTwoDecimals(double price) {
      if (price % 1 == 0) {
        return 'S/ ${price.toInt()}';
      } else {
        return 'S/ ${price.toStringAsFixed(2)}';
      }
    }

    double responsiveValue(double min, double max, int defaultValue) {
      if (MediaQuery.of(context).size.width < defaultValue) {
        return min;
      } else {
        return max;
      }
    }

    return InkWell(
      onTap: () async {
        await Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TripDetailsScreen(tripId: trip.id, auth: auth),
            ),
          );
        });
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
                      child: FadeInImage.assetNetwork(
                          placeholder: 'images/loading.gif',
                          width: responsiveValue(80.0, 100.0, 400),
                          height: responsiveValue(100.0, 120.0, 400),
                          image: trip.thumbnail)),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(14.0, 16.0, 400),
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text(trip.destinationName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(10.0, 12.0, 400))),
                    ],
                  ))
                ],
              ),
              SizedBox(
                  height: responsiveValue(12.0, 24.0, 400),
                  child: const Divider(
                    color: Colors.white10,
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rating",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(12.0, 14.0, 400))),
                      SizedBox(width: responsiveValue(4.0, 8.0, 400)),
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.yellow,
                              size: responsiveValue(16.0, 20.0, 400)),
                          SizedBox(width: responsiveValue(2.0, 8.0, 400)),
                          Text('${trip.averageRating}/5',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveValue(12.0, 14.0, 400))),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(12.0, 14.0, 400))),
                      SizedBox(width: responsiveValue(4.0, 8.0, 400)),
                      Text(formatPriceToPenTwoDecimals(trip.price),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(12.0, 14.0, 400))),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(12.0, 14.0, 400))),
                      SizedBox(width: responsiveValue(4.0, 8.0, 400)),
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
                          SizedBox(width: responsiveValue(2.0, 8.0, 400)),
                          Text(trip.status == 'A' ? 'Open' : 'Closed',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveValue(12.0, 14.0, 400))),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(12.0, 14.0, 400))),
                      SizedBox(width: responsiveValue(4.0, 8.0, 400)),
                      Text(
                          '${DateFormat('dd/MM').format(trip.startDate)} - ${DateFormat('dd/MM').format(trip.endDate)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveValue(12.0, 14.0, 400))),
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
