class Filter {
  String? destination;
  String? season;
  double minPrice;
  double maxPrice;

  Filter({
    this.destination,
    this.season,
    this.minPrice = 0,
    this.maxPrice = 9999.99,
  });

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "season": season,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}