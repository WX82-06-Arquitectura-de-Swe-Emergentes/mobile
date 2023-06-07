import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/shared/globals.dart';

class BarInfoDisplayWidget extends StatelessWidget {
  const BarInfoDisplayWidget( {
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Icon(Icons.location_on, color: Globals.redColor),
              const SizedBox(height: 8.0),
              Text(trip.destination.name,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.access_time, color: Globals.redColor),
              const SizedBox(height: 8.0),
              Text(trip.category,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.group_add, color: Globals.redColor),
              const SizedBox(height: 8.0),
              Text('${trip.groupSize}+',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            children: [
              Icon(Icons.flash_on, color: Globals.redColor),
              const SizedBox(height: 8.0),
              Text(trip.status == 'A' ? 'Available' : 'Unavailable',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
