import 'package:frontend/travel_experience_design_maintenance/domain/entities/filter.dart';

class FilterModel extends Filter {
  FilterModel({
    String? destination,
    String? season,
    double? minPrice,
    double? maxPrice,
  }) : super(
          destination: destination,
          season: season,
          minPrice: minPrice,
          maxPrice: maxPrice,
        );

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "season": season,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
      };
}
