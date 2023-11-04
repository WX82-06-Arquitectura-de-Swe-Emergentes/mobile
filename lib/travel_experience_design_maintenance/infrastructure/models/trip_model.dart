import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip.dart';

class TripModel extends Trip {
  TripModel({
    required int id,
    required String name,
    required double price,
    required String destinationName,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String thumbnail,
    required String averageRating,
  }) : super(
          id: id,
          name: name,
          price: price,
          destinationName: destinationName,
          startDate: startDate,
          endDate: endDate,
          status: status,
          thumbnail: thumbnail,
          averageRating: averageRating,
        );

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        destinationName: json["destination_name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        status: json["status"],
        thumbnail: json["thumbnail"],
        averageRating: json["average_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "destination_name": destinationName,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "status": status,
        "thumbnail": thumbnail,
        "average_rating": averageRating,
      };
}
