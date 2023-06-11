import 'dart:convert';

Destination destinationFromJson(String str) => Destination.fromJson(json.decode(str));

String destinationToJson(Destination data) => json.encode(data.toJson());

class Destination {
    int id;
    String name;
    String description;

    Destination({
        required this.id,
        required this.name,
        required this.description,
    });

    factory Destination.fromJson(Map<String, dynamic> json) => Destination(
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
