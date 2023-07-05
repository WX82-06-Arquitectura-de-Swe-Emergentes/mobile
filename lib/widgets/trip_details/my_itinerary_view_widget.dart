import 'package:flutter/material.dart';
import 'package:frontend/models/trip_item.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/trip_details/map_view.dart';
import 'package:permission_handler/permission_handler.dart';

class MyItineraryViewWidget extends StatelessWidget {
  const MyItineraryViewWidget({super.key, required this.itineraries});

  final List<Itinerary> itineraries;

  @override
  Widget build(BuildContext context) {
    final sortedItineraries = itineraries.toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
          Text(
            'Trip Itinerary',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ]),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sortedItineraries.length,
            itemBuilder: (context, index) {
              return ItineraryItem(itinerary: sortedItineraries[index]);
            },
          ),
        ),
      ],
    );
  }
}

class ItineraryItem extends StatelessWidget {
  const ItineraryItem({Key? key, required this.itinerary}) : super(key: key);

  final Itinerary itinerary;

  @override
  Widget build(BuildContext context) {
    for (final activity in itinerary.activities) {
      print(activity.toString());
    }

    Future<void> openMap(
        String location, double latitude, double longitude) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapView(
              location: location, latitude: latitude, longitude: longitude),
        ),
      );
    }

    Future<bool> setPermissions() async {
      // Request location permission
      final permissionStatus = await Permission.location.request();
      return permissionStatus == PermissionStatus.granted;
    }

    return Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Globals.primaryColor,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 36.0,
                      child: Badge(
                        label: Text(
                          'Day ${itinerary.day}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Globals.redColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setPermissions().then((granted) {
                          if (granted) {
                            // Open Google Maps with the itinerary address
                            openMap(itinerary.location, itinerary.latitude,
                                itinerary.longitude);
                          }
                        });
                      },
                      icon: const Icon(Icons.map),
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: itinerary.activities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_outward,
                              color: Colors.white,
                              size: 16.0,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itinerary.activities[index].name,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      itinerary.activities[index].description,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }
}
