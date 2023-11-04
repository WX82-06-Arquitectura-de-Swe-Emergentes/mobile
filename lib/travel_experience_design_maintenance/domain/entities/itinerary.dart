import 'package:frontend/travel_experience_design_maintenance/domain/entities/activity.dart';

class Itinerary {
  int id;
  int day;
  String location;
  double latitude;
  double longitude;
  List<Activity> activities;

  Itinerary({
    required this.id,
    required this.day,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.activities,
  });
}
