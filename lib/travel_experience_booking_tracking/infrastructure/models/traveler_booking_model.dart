import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking_aggregate.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/models/traveler_booking_aggregate_model.dart';

class TravelerBookingModel extends TravelerBooking {
  TravelerBookingModel({
    required List<TravelerBookingAggregate> upcomingBookings,
    required List<TravelerBookingAggregate> pastBookings,
  }) : super(
          upcomingBookings: upcomingBookings,
          pastBookings: pastBookings,
        );

  // Add fromJson method here
  factory TravelerBookingModel.fromJson(Map<String, dynamic> json) {
    var upcomingBookingsJson = json['upcomingBookings'] as List;
    var pastBookingsJson = json['pastBookings'] as List;

    List<TravelerBookingAggregate> upcomingBookings = upcomingBookingsJson
        .map((i) => TravelerBookingAggregateModel.fromJson(i))
        .toList();

    List<TravelerBookingAggregate> pastBookings = pastBookingsJson
        .map((i) => TravelerBookingAggregateModel.fromJson(i))
        .toList();

    return TravelerBookingModel(
      upcomingBookings: upcomingBookings,
      pastBookings: pastBookings,
    );
  }
}
