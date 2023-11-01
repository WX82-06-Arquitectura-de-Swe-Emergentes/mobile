import 'package:frontend/models/booking_model.dart';

class AgencyBookingView {
  TripModel trip;
  List<BookingModel> bookings;

  AgencyBookingView({
    required this.trip,
    required this.bookings,
  });

  get tripName => trip.name;

  // Add fromJson method here
  factory AgencyBookingView.fromJson(Map<String, dynamic> json) {
    var tripJson = json['trip'] as Map<String, dynamic>;
    var bookingsJson = json['bookings'] as List;

    TripModel trip = TripModel.fromJson(tripJson);
    List<BookingModel> bookings =
        bookingsJson.map((i) => BookingModel.fromJson(i)).toList();

    return AgencyBookingView(
      trip: trip,
      bookings: bookings,
    );
  }
}

class TripModel {
  final int? id;
  final String? status;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? groupSize;
  final int? stock;
  final double? price;
  final dynamic user;
  final Category? category;
  final List<TripDetail>? tripDetails;
  final List<Itinerary>? itineraries;
  final List<dynamic>? reviews;

  TripModel({
    required this.id,
    required this.status,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.groupSize,
    required this.stock,
    required this.price,
    required this.user,
    required this.category,
    required this.tripDetails,
    required this.itineraries,
    required this.reviews,
  });

  @override
  String toString() {
    return 'TripModel{id: $id, status: $status, name: $name, description: $description, startDate: $startDate, endDate: $endDate, groupSize: $groupSize, stock: $stock, price: $price, user: $user, category: $category, tripDetails: $tripDetails, itineraries: $itineraries, reviews: $reviews}';
  }

  // Add fromJson method here
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      status: json['status'],
      name: json['name'],
      description: json['description'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      groupSize: json['group_size'],
      stock: json['stock'],
      // ignore: prefer_null_aware_operators
      price: json['price'] != null ? json['price'].toDouble() : null,
      user: json['user'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      tripDetails: json['tripDetails'] != null
          ? (json['tripDetails'] as List)
              .map((i) => TripDetail.fromJson(i))
              .toList()
          : [],
      itineraries: json['itineraries'] != null
          ? (json['itineraries'] as List)
              .map((i) => Itinerary.fromJson(i))
              .toList()
          : [],
      reviews: json['reviews'],
    );
  }
}

class Category {
  final int? id;
  final String? name;
  final dynamic trips;

  Category({
    required this.id,
    required this.name,
    required this.trips,
  });

  // Add fromJson method here
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      trips: json['trips'],
    );
  }
}

class TripDetail {
  final int id;
  final String imageUrl;

  TripDetail({
    required this.id,
    required this.imageUrl,
  });

  // Add fromJson method here
  factory TripDetail.fromJson(Map<String, dynamic> json) {
    return TripDetail(
      id: json['id'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Itinerary {
  final int? id;
  final int? day;
  final String? location;
  final double? latitude;
  final double? longitude;
  final dynamic trip;
  final dynamic activities;

  Itinerary({
    required this.id,
    required this.day,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.trip,
    required this.activities,
  });

  // Add fromJson method here
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      day: json['day'],
      location: json['location'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      trip: json['trip'],
      activities: json['activities'],
    );
  }
}
