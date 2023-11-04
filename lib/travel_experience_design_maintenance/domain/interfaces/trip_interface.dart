import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';

abstract class TripInterface {
  Future<List<Trip>> getTrips(String token, FilterModel filters);
  Future<TripItem> getTripById(String token, int id);
  Future<List<Destination>> getDestinations(String token);
  Future<List<Season>> getSeasons(String token);
}
