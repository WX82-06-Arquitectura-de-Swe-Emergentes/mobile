import 'package:flutter/material.dart';
import 'package:frontend/services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final service = BookingService();

  dynamic _bookings;
  dynamic get bookings => _bookings;
  set bookings(dynamic value) {
    _bookings = value;
    notifyListeners();
  }

  Future<void> getTravelerTripsBookingsDetails(String token) async {
    try {
      _bookings = await service.getTravelerBookings(token);
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getAgencyTripsBookingsDetails(String token) async {
    try {
      _bookings = await service.getAgencyBookings(token);
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<int> createBooking(String? token, int tripId) async {
    try {
      // final booking = await service.createBooking(token, tripId);
      // _bookings.add(booking);
      // notifyListeners();
      // return booking.id;
      return 0;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _bookings = null;
    notifyListeners();
  }
}
