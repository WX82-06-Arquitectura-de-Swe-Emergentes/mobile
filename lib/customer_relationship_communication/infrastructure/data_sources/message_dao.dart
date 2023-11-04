import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/models/message_model.dart';

class MessageDao {
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref().child('messages');

  Query getMessageQuery() => _messageRef;

  void saveMessage(String chatId, MessageModel message) {
    _messageRef.child(chatId).push().set(message.toJson());
  }
}
