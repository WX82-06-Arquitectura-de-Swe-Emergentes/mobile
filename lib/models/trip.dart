class Trip {
  int id;
  String name;
  double price;
  String destinationName;
  DateTime startDate;
  DateTime endDate;
  String status;
  String thumbnail;
  String averageRating;

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

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        destinationName: json["destination_name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        status: json["status"],
        thumbnail: json["thumbnail"],
        averageRating: json["average_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "destination_name": destinationName,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "status": status,
        "thumbnail": thumbnail,
        "average_rating": averageRating,
      };
}
