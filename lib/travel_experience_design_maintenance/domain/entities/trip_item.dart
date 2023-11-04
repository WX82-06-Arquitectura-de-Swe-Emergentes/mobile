import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/itinerary.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/review.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';

class TripItem {
  TripItem({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
    required this.groupSize,
    required this.stock,
    required this.agencyName,
    required this.category,
    required this.season,
    required this.destination,
    required this.images,
    required this.itineraries,
    required this.reviews,
  });

  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String status;
  final String groupSize;
  final int stock;
  final String agencyName;
  final String category;
  final Season season;
  final Destination destination;
  final List<String> images;
  final List<Itinerary> itineraries;
  final List<Review> reviews;
}
