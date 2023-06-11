import 'package:frontend/models/destination.dart';
import 'package:frontend/models/review.dart';

class TripItem {
  int id;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  double price;
  String status;
  String groupSize;
  String agencyName;

  String category;
  Season season;
  Destination destination;
  List<String> images;
  List<Itinerary> itineraries;
  List<Review> reviews;

  TripItem({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
    required this.groupSize,
    required this.agencyName,
    required this.category,
    required this.season,
    required this.destination,
    required this.images,
    required this.itineraries,
    required this.reviews,
  });

  factory TripItem.fromJson(Map<String, dynamic> json) => TripItem(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        status: json["status"],
        groupSize: json["group_size"],
        agencyName: json["agency_name"],
        category: json["category"],
        season: Season.fromJson(json["season"]),
        destination: Destination.fromJson(json["destination"]),
        images: List<String>.from(json["images"].map((x) => x)),
        itineraries: List<Itinerary>.from(
            json["itineraries"].map((x) => Itinerary.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "price": price,
        "status": status,
        "group_size": groupSize,
        "agency_name": agencyName,
        "category": category,
        "season": season,
        "destination": destination.toJson(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "itineraries": List<dynamic>.from(itineraries.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class Season {
  int id;
  String name;

  Season({
    required this.id,
    required this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

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

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
      id: json["id"],
      day: json["day"],
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      activities: List<Activity>.from(
          json["activities"].map((x) => Activity.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
      };
}

class Activity {
  int id;
  String name;
  String description;

  Activity({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
