import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';

class SeasonModel extends Season {
  SeasonModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
