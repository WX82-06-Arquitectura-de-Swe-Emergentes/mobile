import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/repositories/trip_repository.dart';

class TravelExperienceDesignMaintenanceFacadeService {
  TravelExperienceDesignMaintenanceFacadeService({required this.repository});

  final TripRepository repository;

  Future<List<Trip>> getTrips(String token, FilterModel filters) {
    return repository.getTrips(token, filters);
  }

  Future<TripItem> getTripById(String token, int id) {
    return repository.getTripById(token, id);
  }

  Future<List<Destination>> getDestinations(String token) {
    return repository.getDestinations(token);
  }

  Future<List<Season>> getSeasons(String token) {
    return repository.getSeasons(token);
  }
}
