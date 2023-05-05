import 'package:flutter/material.dart';
import 'package:frontend/models/season.dart';
import 'package:frontend/services/season_service.dart';
import 'package:frontend/services/trip_service.dart';

class SeasonProvider extends ChangeNotifier {
  final service = SeasonService();

  List<Season> _season = [];
  List<Season> get season => _season;
  set trips(List<Season> value) {
    _season = value;
    notifyListeners();
  }

  List<Season> _filteredTrips = [];
  List<Season> get filteredTrips => _filteredTrips;
  set filteredTrips(List<Season> filteredTrips) {
    _filteredTrips = filteredTrips;
    notifyListeners();
  }

  Future<void> getSeasons(String? token) async {
    try {
      _season = await service.getSeasons(token);
      _filteredTrips = _season;
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _season = [];
    _filteredTrips = [];
    notifyListeners();
  }
}
