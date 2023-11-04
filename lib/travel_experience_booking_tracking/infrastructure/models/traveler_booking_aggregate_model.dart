import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking_aggregate.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/models/booking_model.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/trip_item_model.dart';

class TravelerBookingAggregateModel extends TravelerBookingAggregate {
  TravelerBookingAggregateModel({
    required Booking booking,
    required TripItem trip,
  }) : super(
          booking: booking,
          trip: trip,
        );

  // Add fromJson method here
  factory TravelerBookingAggregateModel.fromJson(Map<String, dynamic> json) {
    var bookingJson = json['booking'] as Map<String, dynamic>;
    var tripJson = json['trip'] as Map<String, dynamic>;

    Booking booking = BookingModel.fromJson(bookingJson);
    TripItem trip = TripItemModel.fromJson(tripJson);

    return TravelerBookingAggregateModel(
      booking: booking,
      trip: trip,
    );
  }
}
