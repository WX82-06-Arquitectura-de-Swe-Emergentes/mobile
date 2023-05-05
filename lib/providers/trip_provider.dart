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

  List<Trip> _filteredTrips = [];
  List<Trip> get filteredTrips => _filteredTrips;
  set filteredTrips(List<Trip> filteredTrips) {
    _filteredTrips = filteredTrips;
    notifyListeners();
  }

  Future<void> getTrips() async {
    try {
      _trips = await service.getTrips();
      _filteredTrips = _trips;
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _trips = [];
    _filteredTrips = [];
    notifyListeners();
  }
}
