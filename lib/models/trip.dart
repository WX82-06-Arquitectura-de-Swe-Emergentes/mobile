// To parse this JSON data, do
//
//     final trip = tripFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

Trip tripFromJson(String str) => Trip.fromJson(json.decode(str));

String tripToJson(Trip data) => json.encode(data.toJson());

class Trip {
  int id;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  double price;
  String difficulty;
  String status;
  String groupSize;
  String agencyName;

  String category;
  String season;
  Destination destination;
  List<String> images;
  List<Itinerary> itineraries;

  Trip({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.difficulty,
    required this.status,
    required this.groupSize,
    required this.agencyName,
    required this.category,
    required this.season,
    required this.destination,
    required this.images,
    required this.itineraries,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        difficulty: json["difficulty"],
        status: json["status"],
        groupSize: json["group_size"],
        agencyName: json["agency_name"],
        category: json["category"],
        season: json["season"],
        destination: Destination.fromJson(json["destination"]),
        images: List<String>.from(json["images"].map((x) => x)),
        itineraries: List<Itinerary>.from(
            json["itineraries"].map((x) => Itinerary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "price": price,
        "difficulty": difficulty,
        "status": status,
        "group_size": groupSize,
        "agency_name": agencyName,
        "category": category,
        "season": season,
        "destination": destination.toJson(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "itineraries": List<dynamic>.from(itineraries.map((x) => x.toJson())),
      };
}

class Destination {
  String name;
  String description;

  Destination({
    required this.name,
    required this.description,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
      };
}

class Itinerary {
  int id;
  int day;
  String location;
  double latitude;
  double longitude;
  List<String> activities;

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
        activities: List<String>.from(json["activities"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "activities": List<dynamic>.from(activities.map((x) => x)),
      };
}

class Filter {
  String? destination;
  String? season;
  double minPrice;
  double maxPrice;

  Filter({
    this.destination,
    this.season,
    this.minPrice = 0,
    this.maxPrice = 9999.99,
  });

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "season": season,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}