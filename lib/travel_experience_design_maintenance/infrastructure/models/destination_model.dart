import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';

class DestinationModel extends Destination {
  DestinationModel({
    required int id,
    required String name,
    required String description,
  }) : super(
          id: id,
          name: name,
          description: description,
        );

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      DestinationModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
