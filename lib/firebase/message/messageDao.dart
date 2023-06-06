
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/firebase/message/message.dart';

class MessageDao {
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref().child('messages');

  void saveMessage(String chatId, Message message) {
    _messageRef.child(chatId).push().set(message.toJson());
  }

  Query getMessageQuery() => _messageRef;

}