import 'package:frontend/customer_relationship_communication/domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required String id,
    required String title,
    required String lastMessage,
    required int timestamp,
  }) : super(
          id: id,
          title: title,
          lastMessage: lastMessage,
          timestamp: timestamp,
        );

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) => ChatModel(
        id: json['id'] as String,
        title: json['title'] as String,
        lastMessage: json['lastMessage'] as String,
        timestamp: json['timestamp'] as int,
      );

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'title': title,
        'lastMessage': lastMessage,
        'timestamp': timestamp
      };
}
