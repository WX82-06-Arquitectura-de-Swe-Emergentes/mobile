import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:provider/provider.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({Key? key, required this.token}) : super(key: key);
  final String? token;

  @override
  _TripListScreenState createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final isLoading = ValueNotifier<bool>(true);
  final tripProvider = TripProvider();

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
      await tripProvider.getTrips(widget.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
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
              setState(() {
                isLoading.value = true;
              });
              await tripProvider.getTrips(widget.token);
              setState(() {
                isLoading.value = false;
              });
            },
            child: trips.isEmpty
                ? const Center(child: Text('No hay viajes disponibles'))
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (ct, i) => TripCard(trip: trips[i]),
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
  const TripCard({Key? key, required this.trip}) : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final difference = trip.endDate.difference(trip.startDate);

    return Container(
      width: 300,
      height: 180,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(22, 29, 47, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Coming Soon!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${trip.images[0]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.name,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  trip.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Place: ${trip.destination.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Duration: ${difference.inDays} days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  'Since: ${trip.price}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
