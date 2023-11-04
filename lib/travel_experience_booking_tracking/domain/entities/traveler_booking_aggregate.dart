import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';

class TravelerBookingAggregate {
  TravelerBookingAggregate({
    required this.booking,
    required this.trip,
  });

  final Booking booking;
  final TripItem trip;
}
