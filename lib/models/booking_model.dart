import 'package:frontend/models/trip_item.dart';

class BookingModel {
  final int? id;
  final DateTime? date;
  final String? status;
  final int? numberOfPeople;
  // final dynamic user;
  final TripItem trip;

  BookingModel({
    required this.id,
    required this.date,
    required this.status,
    required this.numberOfPeople,
    // required this.user,
    required this.trip,
  });

  // Add fromJson method here
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      date: DateTime.parse(json["date"]),
      status: json['status'],
      numberOfPeople: json['numberOfPeople'],
      // user: json['user'],
      trip: TripItem.fromJson(json['trip']),
    );
  }
}
