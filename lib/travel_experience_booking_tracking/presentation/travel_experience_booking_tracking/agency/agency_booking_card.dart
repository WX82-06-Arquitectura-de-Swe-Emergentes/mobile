import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/agency_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:intl/intl.dart';

class AgencyBookingCard extends StatelessWidget {
  const AgencyBookingCard({Key? key, required this.data}) : super(key: key);
  final AgencyBooking data;

  @override
  Widget build(BuildContext context) {
    TripItem trip = data.trip;
    List<Booking> bookings = data.bookings;

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
              'Start Date: ${DateFormat('yyyy-MM-dd').format(trip.startDate)}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'End Date: ${DateFormat('yyyy-MM-dd').format(trip.endDate)}',
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
              'Price: ${(Utils.formatPriceToPenTwoDecimals(trip.price))}',
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
