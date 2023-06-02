import 'package:flutter/material.dart';
import 'package:frontend/models/season.dart';
import 'package:frontend/services/season_service.dart';

class SeasonProvider extends ChangeNotifier {
  final service = SeasonService();

  List<Season> _season = [];
  List<Season> get season => _season;
  set trips(List<Season> value) {
    _season = value;
    notifyListeners();
  }

  Future<List<Season>> getSeasons(String? token) async {
    try {
      _season = await service.getSeasons(token);
      return _season;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _season = [];
    notifyListeners();
  }
}
