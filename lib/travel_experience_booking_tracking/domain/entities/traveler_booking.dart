import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking_aggregate.dart';

class TravelerBooking {
  List<TravelerBookingAggregate> upcomingBookings;
  List<TravelerBookingAggregate> pastBookings;

  TravelerBooking({
    required this.upcomingBookings,
    required this.pastBookings,
  });
}
