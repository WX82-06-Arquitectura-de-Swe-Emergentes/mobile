import 'package:frontend/travel_experience_booking_tracking/domain/entities/agency_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/repositories/booking_repository.dart';

class TravelExperienceBookingTrackingFacadeService {
  TravelExperienceBookingTrackingFacadeService({required this.repository});

  final BookingRepository repository;

  Future<TravelerBooking> getTravelerTripsBookingsDetails(String token) {
    return repository.getTravelerTripsBookingsDetails(token);
  }

  Future<List<AgencyBooking>> getAgencyTripsBookingsDetails(String token) {
    return repository.getAgencyTripsBookingsDetails(token);
  }
}
