import 'dart:convert';

import 'package:frontend/models/destination.dart';
import 'package:frontend/services/api_service.dart';

class DestinationService {
  Future<List<Destination>> getDestinations(String? token) async {
    List<Destination> list = [];
    final _token = jsonDecode(token ?? "")['token'];
    Map<String, String> headers = {'Authorization': 'Bearer $_token'};

    final response = await ApiService.get('/destinations', headers);
    list =
        (response as List).map((data) => Destination.fromJson(data)).toList();
    return list;
  }
}
