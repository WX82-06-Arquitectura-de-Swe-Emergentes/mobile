import 'package:flutter/material.dart';
import 'package:frontend/models/booking_model.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:intl/intl.dart';

class TravelerBookingCard extends StatelessWidget {
  const TravelerBookingCard({Key? key, required this.data}) : super(key: key);
  final BookingModel data;
  @override
  Widget build(BuildContext context) {
    dynamic trip = data.trip;

    return Card(
      color: Globals.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking #${data.id}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Trip Name: ${trip.name}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: ${(Utils.formatPriceToPenTwoDecimals(trip.price!))}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${data.status}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(data.date!)}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
