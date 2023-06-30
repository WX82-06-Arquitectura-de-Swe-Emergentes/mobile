class Filter {
  String? destination;
  String? season;
  double minPrice;
  double maxPrice;

  Filter({
    this.destination,
    this.season,
    required this.minPrice,
    required this.maxPrice,
  });

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "season": season,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}
