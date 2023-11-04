class Trip {
  Trip({
    required this.id,
    required this.name,
    required this.price,
    required this.destinationName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.thumbnail,
    required this.averageRating,
  });

  final int id;
  final String name;
  final double price;
  final String destinationName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String thumbnail;
  final String averageRating;
}
