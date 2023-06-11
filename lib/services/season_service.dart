//import 'dart:convert';

import 'package:frontend/models/season.dart';
import 'package:frontend/services/api_service.dart';

class SeasonService {
  Future<List<Season>> getSeasons(String? token) async {
    List<Season> list = [];
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await ApiService.get('/seasons', headers);
    list = (response as List).map((data) => Season.fromJson(data)).toList();
    return list;
  }
}
