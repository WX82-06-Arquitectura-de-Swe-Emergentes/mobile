import 'package:frontend/common/platform/api_connectivity.dart';
import 'package:http/http.dart';

class BookingRemoteDataProvider {
  Future<Response> getTravelerTripsBookingsDetails(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await ApiConnectivity.get("/bookings/traveler", headers);
    return response;
  }

  Future<Response> getAgencyTripsBookingsDetails(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await ApiConnectivity.get("/bookings/agency", headers);
    return response;
  }
}
