class Booking {
  Booking({
    required this.id,
    required this.thumbnail,
    required this.tripName,
    required this.date,
    required this.price,
    required this.status,
  });

  final int id;
  final String thumbnail;
  final String tripName;
  final DateTime date;
  final double price;
  final String status;
}
