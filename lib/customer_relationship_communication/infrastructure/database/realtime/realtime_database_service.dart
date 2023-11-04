import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/data_sources/chat_dao.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/data_sources/member_dao.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/data_sources/message_dao.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/models/message_model.dart';

class RealtimeDatabaseService {
  final _chatDao = ChatDao();
  final _memberDao = MemberDao();
  final _messageDao = MessageDao();
  final _database = FirebaseDatabase.instance.ref();

  get database => _database;
  get chatDao => _chatDao;
  get memberDao => _memberDao;
  get messageDao => _messageDao;

  Future<List<Map<dynamic, dynamic>>> loadChatsForMember(
      String username) async {
    final chats = <Map<dynamic, dynamic>>[];

    final memberQuery =
        _memberDao.getMemberQuery().orderByChild(username).equalTo(true);

    final DatabaseEvent memberSnapshot = await memberQuery.once();
    final json = memberSnapshot.snapshot.value as Map<dynamic, dynamic>;
    final memberChatsIds = json.keys.toList();

    final chatQuery = _chatDao.getChatQuery();
    final chatSnapshot = await chatQuery.once();
    final chatJson = chatSnapshot.snapshot.value as Map<dynamic, dynamic>;

    chatJson.forEach((key, value) {
      if (memberChatsIds.contains(key)) {
        chats.add(value);
      }
    });

    return chats;
    // return chats.map((e) => ChatModel.fromJson(e)).toList();
  }

  Future<String> findReceptor(String username, String chatId) async {
    final emisor = username;
    final memberQuery = _memberDao.getMemberRef().child(chatId);
    final memberSnapshot = await memberQuery.once();
    final json = memberSnapshot.snapshot.value as Map<dynamic, dynamic>;
    final receptor = json.keys.toList().firstWhere((key) => key != emisor);
    return receptor;
  }

  Future<void> sendMessage(
      String username, String chatId, String message) async {
    MessageModel newMessage = MessageModel(
      name: username,
      message: message,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _messageDao.saveMessage(chatId, newMessage);
    DatabaseReference chatRef = _chatDao.getChatRef();

    chatRef.child(chatId).update({
      "lastMessage": newMessage.message,
      "timestamp": newMessage.timestamp,
    });
  }
}
