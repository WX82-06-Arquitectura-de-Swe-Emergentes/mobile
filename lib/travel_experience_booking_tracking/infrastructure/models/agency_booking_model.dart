import 'package:frontend/travel_experience_booking_tracking/domain/entities/agency_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/models/booking_model.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/trip_item_model.dart';

class AgencyBookingModel extends AgencyBooking {
  AgencyBookingModel({
    required TripItem trip,
    required List<Booking> bookings,
  }) : super(
          trip: trip,
          bookings: bookings,
        );

  // Add fromJson method here
  factory AgencyBookingModel.fromJson(Map<String, dynamic> json) {
    var tripJson = json['trip'] as Map<String, dynamic>;
    var bookingsJson = json['bookings'] as List;

    TripItem trip = TripItemModel.fromJson(tripJson);
    List<Booking> bookings =
        bookingsJson.map((i) => BookingModel.fromJson(i)).toList();

    return AgencyBookingModel(
      trip: trip,
      bookings: bookings,
    );
  }
}
