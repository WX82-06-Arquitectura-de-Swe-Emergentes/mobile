import 'package:frontend/models/trip.dart';
import 'package:frontend/services/api_service.dart';

String buildFilterUrl(Filter filters) {
  final params = filters.toJson();
  final nonNullParams = params.entries.where((entry) => entry.value != null);
  final query = nonNullParams.map((entry) => '${entry.key}=${entry.value}').join('&');
  final encodedQuery = Uri.encodeFull(query);
  return '/trips/filter?$encodedQuery';
}

class TripService {

  Future<List<Trip>> getTrips(String? token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await ApiService.get('/trips', headers);
    return (response as List).map((data) => Trip.fromJson(data)).toList();
  }

  Future<List<Trip>> getTripsFilter(String? token, Filter filters) async {
    final headers = {'Authorization': 'Bearer $token'};
    final url = buildFilterUrl(filters);
    final response = await ApiService.get(url, headers);
    return (response as List).map((data) => Trip.fromJson(data)).toList();
  }
}
