import 'package:flutter/material.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/services/destination.service.dart';

class DestinationProvider extends ChangeNotifier {
  final service = DestinationService();

  List<Destination> _destination = [];
  List<Destination> get destination => _destination;
  set destintion(List<Destination> value) {
    _destination = value;
    notifyListeners();
  }

  Future<List<Destination>> getDestinations(String? token) async {
    try {
      _destination = await service.getDestinations(token);
      return _destination;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _destination = [];
    notifyListeners();
  }
}
