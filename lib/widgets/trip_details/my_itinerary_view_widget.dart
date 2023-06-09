import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/shared/globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyItineraryViewWidget extends StatelessWidget {
  const MyItineraryViewWidget({super.key, required this.itineraries});

  final List<Itinerary> itineraries;

  @override
  Widget build(BuildContext context) {
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
            itemCount: itineraries.length,
            itemBuilder: (context, index) {
              return ItineraryItem(itinerary: itineraries[index]);
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
                        // Open Google Maps with the itinerary address
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
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Text(
                                itinerary.activities[index],
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
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

// class ItineraryItem extends StatelessWidget {
//   const ItineraryItem({super.key, required this.itinerary});

//   final Itinerary itinerary;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Globals.primaryColor,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Expanded(
//           //   child: GoogleMap(
//           //     initialCameraPosition: CameraPosition(
//           //       target: LatLng(latitude, longitude),
//           //       zoom: 15.0,
//           //     ),
//           //     markers: {
//           //       Marker(
//           //         markerId: const MarkerId('exact_location'),
//           //         position: LatLng(latitude, longitude),
//           //       ),
//           //     },
//           //   ),
//           // ),
//           Row(children: [
//             Text("hi", style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),),Text("hi", style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),)
//           ],),
//           Text(
//             "Day ${itinerary.day}",
//             style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: itinerary.activities.map((activity) {
//               return Row(
//                 children: [
//                   const Icon(Icons.check, color: Colors.green),
//                   const SizedBox(width: 8.0),
//                   Text(
//                     activity,
//                     style: const TextStyle(fontSize: 16.0, color: Colors.white),
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
