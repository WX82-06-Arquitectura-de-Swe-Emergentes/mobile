import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/shared/globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItineraryViewWidget extends StatelessWidget {
  const ItineraryViewWidget(
      {super.key,
      required this.visibleItineraries,
      required this.sortedItineraries,
      required this.showAllItineraries});

  final List<Itinerary> sortedItineraries;
  final Iterable<Itinerary> visibleItineraries;
  final bool showAllItineraries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ITINERARY',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 2.0,
            width: 50.0,
            color: Globals.redColor,
          ),
          const SizedBox(height: 8.0),
          Column(
            children: visibleItineraries.map((it) {
              return Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text(
                          'DAY ${it.day}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'LOCATION',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          it.location,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'ACTIVITIES',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: it.activities.map((activity) {
                            return Row(
                              children: [
                                const Icon(Icons.check, color: Colors.green),
                                const SizedBox(width: 8.0),
                                Text(
                                  activity,
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height:
                            200.0, // Ajusta la altura del mapa según tus necesidades
                        child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(it.latitude, it.longitude),
                              zoom: 15.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('exact_location'),
                                position: LatLng(it.latitude, it.longitude),
                                infoWindow:
                                    const InfoWindow(title: 'Exact Location'),
                              ),
                            }),
                      ),
                    ),
                  ],
                ),
              ]);
            }).toList(),
          ),
          if (!showAllItineraries) const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    color: Globals.backgroundColor,
                    height: MediaQuery.of(context).size.height * .9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 16.0),
                            const Text(
                              'Itineraries',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: sortedItineraries.map((it) {
                                return Container(
                                  padding: const EdgeInsets.all(32.0),
                                  margin: const EdgeInsets.only(bottom: 0.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DAY ${it.day}',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        "Location:  ${it.location}",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'ACTIVITIES',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: it.activities.map((activity) {
                                          return Row(
                                            children: [
                                              const Icon(Icons.check,
                                                  color: Colors.green),
                                              const SizedBox(width: 8.0),
                                              Text(
                                                activity,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[400]!),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: SizedBox(
                                          height: 200.0,
                                          child: GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  it.latitude, it.longitude),
                                              zoom: 15.0,
                                            ),
                                            markers: {
                                              Marker(
                                                markerId: const MarkerId(
                                                    'exact_location'),
                                                position: LatLng(
                                                    it.latitude, it.longitude),
                                                infoWindow: const InfoWindow(
                                                    title: 'Exact Location'),
                                              ),
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Globals.redColor,
            ),
            child: const Text('See More'),
          ),
        ],
      ),
    );
  }
}
