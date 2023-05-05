import 'package:frontend/models/trip.dart';
import 'package:frontend/services/api_service.dart';

class TripService {
  //final app = AppServices();

  Future<List<Trip>> getTrips(String? token) async {
    List<Trip> list = [];
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await ApiService.get('/trips', headers);
    list = (response as List).map((data) => Trip.fromJson(data)).toList();
    return list;
  }
}
