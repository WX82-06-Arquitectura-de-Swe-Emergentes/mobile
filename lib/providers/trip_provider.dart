import 'package:flutter/material.dart';
import 'package:frontend/models/filter.dart';

import '../models/trip.dart';
import '../services/trip_service.dart';

class TripProvider extends ChangeNotifier {
  final service = TripService();

  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  Trip getTrip(int index) {
    return _trips[index];
  }

  get isEmpty => _trips.isEmpty;
  get size => _trips.length;
  set trips(List<Trip> value) {
    _trips = value;
    notifyListeners();
  }

  Future<void> getTrips(String? token, Filter? filters) async {
    try {
      _trips = await service.getTrips(token, filters);
      notifyListeners();
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getTripsByRoleViaToken(String? token, Filter? filters) async {
    try {
      _trips = await service.getTripsByRoleViaToken(token, filters);
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
