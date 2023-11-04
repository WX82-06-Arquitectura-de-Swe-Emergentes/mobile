import 'package:flutter/material.dart';
import 'package:frontend/injections.dart';
import 'package:frontend/travel_experience_design_maintenance/application/travel_experience_design_maintenance_facade_service.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';

class TravelExperienceDesignMaintenanceApi extends ChangeNotifier {
  final TravelExperienceDesignMaintenanceFacadeService
      travelExperienceDesignMaintenanceApiFacade =
      serviceLocator<TravelExperienceDesignMaintenanceFacadeService>();

  // Trips
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  Trip getTrip(int index) => _trips[index];

  get isEmpty => _trips.isEmpty;
  get size => _trips.length;
  set trips(List<Trip> value) {
    _trips = value;
    notifyListeners();
  }

  // Destination
  List<Destination> _destinations = [];
  List<Destination> get destinations => _destinations;
  Destination getDestination(int index) => _destinations[index];

  // Season
  List<Season> _seasons = [];
  List<Season> get seasons => _seasons;
  Season getSeason(int index) => _seasons[index];

  // Methods
  Future<List<Trip>> getTrips(String token, FilterModel filters) async {
    final List<Trip> trips = await travelExperienceDesignMaintenanceApiFacade
        .getTrips(token, filters);
    _trips = trips;
    notifyListeners();
    return trips;
  }

  Future<List<Destination>> getDestinations(String token) async {
    final List<Destination> destinations =
        await travelExperienceDesignMaintenanceApiFacade.getDestinations(token);
    _destinations = destinations;
    notifyListeners();
    return destinations;
  }

  Future<List<Season>> getSeasons(String token) async {
    final List<Season> seasons =
        await travelExperienceDesignMaintenanceApiFacade.getSeasons(token);
    _seasons = seasons;
    notifyListeners();
    return seasons;
  }

  Future<TripItem> getTripById(String token, int id) async {
    final TripItem trip =
        await travelExperienceDesignMaintenanceApiFacade.getTripById(token, id);
    notifyListeners();
    return trip;
  }
}
