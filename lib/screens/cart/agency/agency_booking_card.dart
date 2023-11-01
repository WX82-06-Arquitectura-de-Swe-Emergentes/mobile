import 'package:flutter/material.dart';
import 'package:frontend/models/agency_booking.dart';
import 'package:frontend/models/booking_model.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:intl/intl.dart';

class AgencyBookingCard extends StatelessWidget {
  const AgencyBookingCard({Key? key, required this.data}) : super(key: key);
  final AgencyBookingView data;

  @override
  Widget build(BuildContext context) {
    TripModel trip = data.trip;
    List<BookingModel> bookings = data.bookings;

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
              'Trip Name: ${trip.name}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Start Date: ${DateFormat('yyyy-MM-dd').format(trip.startDate!)}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'End Date: ${DateFormat('yyyy-MM-dd').format(trip.endDate!)}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Group Size: ${trip.groupSize}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Stock: ${trip.stock}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: ${(Utils.formatPriceToPenTwoDecimals(trip.price!))}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Bookings: ${bookings.length}',
              style: const TextStyle(color: Colors.white),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
