import 'package:frontend/models/agency_booking.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/traveler.booking.dart';
import 'package:frontend/services/api_service.dart';
import 'dart:convert';

class BookingService {
  // Future<List<Booking>> getBookings(String token, Role role) async {
  //   List<Booking> list = [];
  //   Map<String, String> headers = {'Authorization': 'Bearer $token'};

  //   final response = await ApiService.get(
  //       '/bookings/my-bookings?role=${role.name}', headers);
  //   list = (response as List).map((data) => Booking.fromJson(data)).toList();
  //   return list;
  // }

  Future<dynamic> getTravelerBookings(String token) async {
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await ApiService.get("/bookings/traveler", headers);

    return TravelerBookingView.fromJson(response);
  }

  Future<List<AgencyBookingView>> getAgencyBookings(String token) async {
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await ApiService.get("/bookings/agency", headers);

    List<AgencyBookingView> tripWithBookingsList =
        (response as List).map((i) => AgencyBookingView.fromJson(i)).toList();

    return tripWithBookingsList;
  }

  Future<Booking> createBooking(String? token, int tripId) async {
    const endpoint = '/bookings';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = {'tripId': tripId};

    final response = await ApiService.post(endpoint, headers, body);
    final responseJSON = jsonDecode(response.body);
    return Booking.fromJson(responseJSON);
  }
}
