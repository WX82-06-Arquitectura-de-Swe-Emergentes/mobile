// ignore_for_file: unnecessary_null_comparison

import 'package:frontend/common/platform/api_connectivity.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';
import 'package:http/http.dart';

String buildFilterEndpoint(String baseEndpoint, FilterModel filters) {
  final params = filters.toJson();
  final nonNullParams = params.entries.where((entry) => entry.value != null);
  final query =
      nonNullParams.map((entry) => '${entry.key}=${entry.value}').join('&');
  final encodedQuery = Uri.encodeFull(query);
  return '$baseEndpoint/filter?$encodedQuery';
}

class TripRemoteDataProvider {
  Future<Response> getTrips(String token, FilterModel filters) async {
    final headers = {'Authorization': 'Bearer $token'};
    const baseEndpoint = '/trips';
    final endpoint = filters != null
        ? buildFilterEndpoint(baseEndpoint, filters)
        : baseEndpoint;
    final response = await ApiConnectivity.get(endpoint, headers);
    return response;
  }

  Future<Response> getTripById(String token, int id) async {
    final headers = {'Authorization': 'Bearer $token'};
    final endpoint = '/trips/${id.toString()}';
    final response = await ApiConnectivity.get(endpoint, headers);
    return response;
  }

  Future<Response> getDestinations(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    const endpoint = '/destinations';
    final response = await ApiConnectivity.get(endpoint, headers);
    return response;
  }

  Future<Response> getSeasons(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    const endpoint = '/seasons';
    final response = await ApiConnectivity.get(endpoint, headers);
    return response;
  }
}
