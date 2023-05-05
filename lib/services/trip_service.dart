import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/trip.dart';
import 'package:frontend/providers/services.dart';
import 'package:frontend/services/api_service.dart';

class TripService {
  //final app = AppServices();

  Future<List<Trip>> getTrips() async {
    List<Trip> list = [];
    final response = await ApiService.get('/trips');
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => Trip.fromJson(data))
          .toList();
      return list;
    } else {
      inspect(response);
      throw Exception('Failed to load data');
    }
  }
}
