import 'package:frontend/models/booking_model.dart';

class TravelerBookingView {
  List<BookingModel> upcomingBookings;
  List<BookingModel> pastBookings;

  TravelerBookingView({
    required this.upcomingBookings,
    required this.pastBookings,
  });

  // Add fromJson method here
  factory TravelerBookingView.fromJson(Map<String, dynamic> json) {
    var upcomingBookingsJson = json['upcomingBookings'] as List;
    var pastBookingsJson = json['pastBookings'] as List;

    return TravelerBookingView(
      upcomingBookings:
          upcomingBookingsJson.map((i) => BookingModel.fromJson(i)).toList(),
      pastBookings:
          pastBookingsJson.map((i) => BookingModel.fromJson(i)).toList(),
    );
  }
}