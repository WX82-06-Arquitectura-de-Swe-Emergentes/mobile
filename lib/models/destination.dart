import 'dart:convert';

Destination destinationFromJson(String str) => Destination.fromJson(json.decode(str));

String destinationToJson(Destination data) => json.encode(data.toJson());

class Destination {
    int destinationId;
    String name;
    String description;

    Destination({
        required this.destinationId,
        required this.name,
        required this.description,
    });

    factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        destinationId: json["destination_id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "destination_id": destinationId,
        "name": name,
        "description": description,
    };
}
