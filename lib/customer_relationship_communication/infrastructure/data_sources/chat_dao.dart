import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/models/chat_model.dart';

class ChatDao {
  final DatabaseReference _chatRef =
      FirebaseDatabase.instance.ref().child('chats');

  Query getChatQuery() => _chatRef;
  DatabaseReference getChatRef() => _chatRef;

  void saveChat(ChatModel chat) {
    _chatRef.push().set(chat.toJson());
  }
}
