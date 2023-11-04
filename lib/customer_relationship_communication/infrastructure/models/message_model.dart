import 'package:frontend/customer_relationship_communication/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String name,
    required String message,
    required int timestamp,
  }) : super(
          name: name,
          message: message,
          timestamp: timestamp,
        );

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) => MessageModel(
        name: json['name'] as String,
        message: json['message'] as String,
        timestamp: json['timestamp'] as int,
      );

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name,
        'message': message,
        'timestamp': timestamp
      };
}
