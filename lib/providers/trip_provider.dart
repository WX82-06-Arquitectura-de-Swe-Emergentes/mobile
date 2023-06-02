import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../services/trip_service.dart';

class TripProvider extends ChangeNotifier {
  final service = TripService();

  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  set trips(List<Trip> value) {
    _trips = value;
    notifyListeners();
  }

  Future<void> getTrips(String? token) async {
    try {
      _trips = await service.getTrips(token);
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getTripsFilter(String? token,Filter filters) async {
    try {
      _trips = await service.getTripsFilter(token,filters);
      notifyListeners();
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _trips = [];
    notifyListeners();
  }
}
