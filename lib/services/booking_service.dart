import 'package:frontend/models/booking.dart';
import 'package:frontend/services/api_service.dart';

class BookingService {
  Future<List<Booking>> getBookings(String token, String role) async {
    List<Booking> list = [];
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response =
        await ApiService.get('/bookings/my-bookings?role=$role', headers);
    list = (response as List).map((data) => Booking.fromJson(data)).toList();
    return list;
  }

  Future<Booking> createBooking(String? token, int tripId) async {
    const endpoint = '/bookings';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = {'tripId': tripId};

    final response = await ApiService.post(endpoint, headers, body);
    return Booking.fromJson(response);
  }
}
