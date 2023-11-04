import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/itinerary.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/review.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/destination_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/itinerary_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/review_model.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/season_model.dart';

class TripItemModel extends TripItem {
  TripItemModel({
    required int id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required double price,
    required String status,
    required String groupSize,
    required int stock,
    required String agencyName,
    required String category,
    required Season season,
    required Destination destination,
    required List<String> images,
    required List<Itinerary> itineraries,
    required List<Review> reviews,
  }) : super(
          id: id,
          name: name,
          description: description,
          startDate: startDate,
          endDate: endDate,
          price: price,
          status: status,
          groupSize: groupSize,
          stock: stock,
          agencyName: agencyName,
          category: category,
          season: season,
          destination: destination,
          images: images,
          itineraries: itineraries,
          reviews: reviews,
        );

  factory TripItemModel.fromJson(Map<String, dynamic> json) => TripItemModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        status: json["status"],
        groupSize: json["group_size"],
        stock: json["stock"],
        agencyName: json["agency_name"],
        category: json["category"],
        season: SeasonModel.fromJson(json["season"]),
        destination: DestinationModel.fromJson(json["destination"]),
        images: List<String>.from(json["images"].map((x) => x)),
        itineraries: List<ItineraryModel>.from(
            json["itineraries"].map((x) => ItineraryModel.fromJson(x))),
        reviews: List<ReviewModel>.from(
            json["reviews"].map((x) => ReviewModel.fromJson(x))),
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
        "stock": stock,
        "agency_name": agencyName,
        "category": category,
        "season": season,
        "destination": destination,
        "images": images,
        "itineraries": itineraries,
        "reviews": reviews,
      };
}
