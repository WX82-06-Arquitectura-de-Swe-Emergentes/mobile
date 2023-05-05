import 'dart:convert';

import 'package:frontend/models/season.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/services/api_service.dart';

class TripService {
  //final app = AppServices();

  Future<List<Trip>> getTrips(String? token) async {
    List<Trip> list = [];
    final _token = jsonDecode(token ?? "")['token'];
    Map<String, String> headers = {'Authorization': 'Bearer $_token'};

    final response = await ApiService.get('/trips', headers);
    list = (response as List).map((data) => Trip.fromJson(data)).toList();
    return list;
  }

  Future<List<Season>> getTripsBySeasons(String? token) async {
    List<Season> list = [];
    final _token = jsonDecode(token ?? "")['token'];
    Map<String, String> headers = {'Authorization': 'Bearer $_token'};

    final response = await ApiService.get('/tripsBySeason', headers);
    list = (response as List).map((data) => Season.fromJson(data)).toList();
    return list;
  }

  Future<List<Destination>> getTripsByDestinations(String? token) async {
    List<Destination> list = [];
    final _token = jsonDecode(token ?? "")['token'];
    Map<String, String> headers = {'Authorization': 'Bearer $_token'};

    final response = await ApiService.get('/tripByDestinations', headers);
    list =
        (response as List).map((data) => Destination.fromJson(data)).toList();
    return list;
  }
}
