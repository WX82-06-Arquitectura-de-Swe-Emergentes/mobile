import 'package:frontend/models/trip.dart';
import 'package:frontend/services/api_service.dart';

class DestinationService {
  Future<List<Destination>> getDestinations(String? token) async {
    List<Destination> list = [];
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    
    final response = await ApiService.get('/destinations', headers);
    list =
        (response as List).map((data) => Destination.fromJson(data)).toList();
    return list;
  }
}
