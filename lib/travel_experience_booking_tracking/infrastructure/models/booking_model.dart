import 'package:frontend/travel_experience_booking_tracking/domain/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel(
      {required int id,
      required String thumbnail,
      required String tripName,
      required DateTime date,
      required double price,
      required String status})
      : super(
            id: id,
            thumbnail: thumbnail,
            tripName: tripName,
            date: date,
            price: price,
            status: status);

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json["id"],
        thumbnail: json["thumbnail"],
        tripName: json["tripName"],
        date: DateTime.parse(json["date"]),
        price: json["price"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "thumbnail": thumbnail,
        "trip_name": tripName,
        "date": date.toIso8601String(),
        "price": price,
        "status": status,
      };
}
