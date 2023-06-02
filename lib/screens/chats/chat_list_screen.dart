import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chatDao.dart';
import 'package:frontend/firebase/member/memberDao.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/chats/chat_conversation_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/widgets/app_bar.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key, required this.auth}) : super(key: key);
  final AuthenticationProvider auth;

  @override
  // ignore: library_private_types_in_public_api
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final database = FirebaseDatabase.instance.ref();
  final chatDao = ChatDao();
  final memberDao = MemberDao();
  late List<Map<dynamic, dynamic>> chats;

  @override
  void initState() {
    super.initState();
    chats = [];
    _loadChatsForMember();
  }

  Future<void> _loadChatsForMember() async {
    final _chats = <Map<dynamic, dynamic>>[];
     memberDao
        .getMemberQuery()
        .orderByChild(widget.auth.username)
        .equalTo(true)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        return;
      }

      final json = event.snapshot.value as Map<dynamic, dynamic>;
      final memberChatsIds = json.keys.toList();

      chatDao.getChatQuery().onValue.listen((DatabaseEvent event) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;

        json.forEach((key, value) {
          if (memberChatsIds.contains(key)) {
            Chat _chatCopy = Chat.fromJson(value);
            _chatCopy.id = key;
            _chats.add(_chatCopy.toJson());
          }
        });
        setStateIfMounted(_chats);
      });
    });
  }

  void setStateIfMounted(f) {
    if (mounted) {
      setState(() {
        chats = f;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: const AppBarBack(),
        backgroundColor: Globals.backgroundColor,
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final conversation = chats[index];
                    return ListTile(
                        title: Text(conversation['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        subtitle: Text(conversation['lastMessage'],
                            style: const TextStyle(color: Colors.white70)),
                        leading: CircleAvatar(
                          child: Text(conversation['title'][0],
                              style: const TextStyle(color: Colors.white)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatConversationScreen(
                                  chat: Chat.fromJson(conversation),
                                  auth: widget.auth),
                            ),
                          );
                        });
                  }))
        ]));
  }
}
