import 'dart:convert';

import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/interfaces/trip_interface.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/data_sources/trip_remote_provider.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/destination_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/season_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/trip_item_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/trip_model.dart';
import 'package:http/http.dart';

class TripRepository implements TripInterface {
  TripRepository({
    required this.tripRemoteDataProvider,
  });

  final TripRemoteDataProvider tripRemoteDataProvider;

  @override
  Future<List<Trip>> getTrips(String token, FilterModel filters) async {
    try {
      final Response response =
          await tripRemoteDataProvider.getTrips(token, filters);
      final List<dynamic> tripList = jsonDecode(response.body);
      return tripList.map((trip) => TripModel.fromJson(trip)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<TripItem> getTripById(String token, int id) async {
    try {
      final Response response =
          await tripRemoteDataProvider.getTripById(token, id);
      final Map<String, dynamic> tripMap = jsonDecode(response.body);
      return TripItemModel.fromJson(tripMap);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Destination>> getDestinations(String token) async {
    try {
      final Response response =
          await tripRemoteDataProvider.getDestinations(token);
      final List<dynamic> destinationList = jsonDecode(response.body);
      return destinationList
          .map((destination) => DestinationModel.fromJson(destination))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Season>> getSeasons(String token) async {
    try {
      final Response response = await tripRemoteDataProvider.getSeasons(token);
      final List<dynamic> seasonList = jsonDecode(response.body);
      return seasonList.map((season) => SeasonModel.fromJson(season)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
