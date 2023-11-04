import 'package:frontend/travel_experience_design_maintenance/domain/entities/activity.dart';

class ActivityModel extends Activity {
  ActivityModel({
    required int id,
    required String name,
    required String description,
  }) : super(
          id: id,
          name: name,
          description: description,
        );

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
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
