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
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(22, 29, 47, 1),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.count(
                  primary: false,
                  //padding: const EdgeInsets.all(5),
                  
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: [
                    Image.network(
                      scale: 0.3,
                      fit: BoxFit.cover,
                      '${trip.images[0]}',
                    ),
                    Column(children: [
                      Text(
                        '${trip.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${trip.description}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Place: ${trip.destination.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Duration: ${difference.inDays} days',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    Text(
                      'Since: ${trip.price}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
