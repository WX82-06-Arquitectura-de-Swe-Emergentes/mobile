import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/firebase/chat/chat.dart';

class ChatDao {
  final DatabaseReference _chatRef =
      FirebaseDatabase.instance.ref().child('chats');

  Query getChatQuery() => _chatRef;

  DatabaseReference getChatRef() => _chatRef;

  void saveChat(Chat chat) {
    _chatRef.push().set(chat.toJson());
  }
}
