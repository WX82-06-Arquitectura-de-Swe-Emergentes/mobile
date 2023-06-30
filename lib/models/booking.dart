class Booking {
  int id;
  String thumbnail;
  String tripName;
  DateTime date;
  double price;
  String status;

  Booking({
    required this.id,
    required this.thumbnail,
    required this.tripName,
    required this.date,
    required this.price,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
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
