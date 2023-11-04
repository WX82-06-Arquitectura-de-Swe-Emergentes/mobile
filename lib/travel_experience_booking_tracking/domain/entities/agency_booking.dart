import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';

class AgencyBooking {
  TripItem trip;
  List<Booking> bookings;

  AgencyBooking({
    required this.trip,
    required this.bookings,
  });
}
