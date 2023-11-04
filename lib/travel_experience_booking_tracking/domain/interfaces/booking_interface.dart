import 'package:frontend/travel_experience_booking_tracking/domain/entities/agency_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking.dart';

abstract class BookingInterface {
  Future<TravelerBooking> getTravelerTripsBookingsDetails(String token);
  Future<List<AgencyBooking>> getAgencyTripsBookingsDetails(String token);
}
