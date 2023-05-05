import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/services/destination.service.dart';

class DestinationProvider extends ChangeNotifier {
  final service = DestinationService();

  List<Destination> _destination = [];
  List<Destination> get destination => _destination;
  set trips(List<Destination> value) {
    _destination = value;
    notifyListeners();
  }

  List<Destination> _filteredTrips = [];
  List<Destination> get filteredTrips => _filteredTrips;
  set filteredTrips(List<Destination> filteredTrips) {
    _filteredTrips = filteredTrips;
    notifyListeners();
  }

  Future<void> getDetination(String? token) async {
    try {
      _destination = (await service.getDestinations(token)).cast<Destination>();
      _filteredTrips = _destination;
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _destination = [];
    _filteredTrips = [];
    notifyListeners();
  }
}
