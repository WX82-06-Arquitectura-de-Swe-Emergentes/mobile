import 'package:frontend/travel_experience_design_maintenance/domain/entities/activity.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/itinerary.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/activity_model.dart';

class ItineraryModel extends Itinerary {
  ItineraryModel({
    required int id,
    required int day,
    required String location,
    required double latitude,
    required double longitude,
    required List<Activity> activities,
  }) : super(
          id: id,
          day: day,
          location: location,
          latitude: latitude,
          longitude: longitude,
          activities: activities,
        );

  factory ItineraryModel.fromJson(Map<String, dynamic> json) => ItineraryModel(
      id: json["id"],
      day: json["day"],
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      activities: List<ActivityModel>.from(
          json["activities"].map((x) => ActivityModel.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "activities": activities,
      };
}
