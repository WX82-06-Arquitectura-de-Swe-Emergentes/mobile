import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking_aggregate.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:intl/intl.dart';

class TravelerBookingCard extends StatelessWidget {
  const TravelerBookingCard({Key? key, required this.data}) : super(key: key);
  final TravelerBookingAggregate data;
  @override
  Widget build(BuildContext context) {
    Booking booking = data.booking;
    TripItem trip = data.trip;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking #${booking.id}",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  '${Utils.getFormattedDate(trip.startDate)} - ${Utils.getFormattedDate(trip.endDate)}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
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
              'Price: ${(Utils.formatPriceToPenTwoDecimals(trip.price))}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${booking.status}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Purchase Date: ${DateFormat('yyyy-MM-dd').format(booking.date)}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
