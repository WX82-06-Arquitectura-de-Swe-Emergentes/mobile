import 'package:flutter/material.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final service = BookingService();

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;
  set bookings(List<Booking> value) {
    _bookings = value;
    notifyListeners();
  }

  Future<void> getBookings(String token, String role) async {
    try {
      _bookings = await service.getBookings(token, role);
      print(_bookings);
      return;
    } catch (e) {
      print(e);
      throw Exception('Failed to load data');
    }
  }

  Future<int> createBooking(String? token, int tripId) async {
    try {
      final booking = await service.createBooking(token, tripId);
      _bookings.add(booking);
      notifyListeners();
      return booking.id;
    } catch (e) {
      print(e);
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _bookings = [];
    notifyListeners();
  }
}
