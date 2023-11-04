import 'package:flutter/material.dart';
import 'package:frontend/injections.dart';
import 'package:frontend/travel_experience_booking_tracking/application/travel_experience_booking_tracking_facade_service.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/agency_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking.dart';

class TravelExperienceBookingTrackingApi extends ChangeNotifier {
  final TravelExperienceBookingTrackingFacadeService
      travelExperienceBookingTrackingFacade =
      serviceLocator<TravelExperienceBookingTrackingFacadeService>();

  dynamic _bookings;
  dynamic get bookings => _bookings;
  set bookings(dynamic value) {
    _bookings = value;
    notifyListeners();
  }

  Future<void> getTravelerTripsBookingsDetails(String token) async {
    final TravelerBooking travelerBookings =
        await travelExperienceBookingTrackingFacade
            .getTravelerTripsBookingsDetails(token);
    _bookings = travelerBookings;
    notifyListeners();
    return;
  }

  Future<void> getAgencyTripsBookingsDetails(String token) async {
    final List<AgencyBooking> agencyBookings =
        await travelExperienceBookingTrackingFacade
            .getAgencyTripsBookingsDetails(token);
    _bookings = agencyBookings;
    notifyListeners();
    return;
  }
}
