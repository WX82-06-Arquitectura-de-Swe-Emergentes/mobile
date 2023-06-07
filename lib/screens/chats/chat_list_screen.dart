import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chatDao.dart';
import 'package:frontend/firebase/member/memberDao.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/chats/chat_conversation_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

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

  // Future<void> _loadChatsForMember() async {
  //   final _chats = <Map<dynamic, dynamic>>[];
  //   memberDao
  //       .getMemberQuery()
  //       .orderByChild(widget.auth.username)
  //       .equalTo(true)
  //       .onValue
  //       .listen((DatabaseEvent event) {
  //     if (event.snapshot.value == null) {
  //       return;
  //     }

  //     final json = event.snapshot.value as Map<dynamic, dynamic>;
  //     final memberChatsIds = json.keys.toList();

  //     chatDao.getChatQuery().onValue.listen((DatabaseEvent event) {
  //       final json = event.snapshot.value as Map<dynamic, dynamic>;
  //       json.forEach((key, value) {
  //         print(key);
  //         if (memberChatsIds.contains(key)) {
  //           Chat chatCopy = Chat.fromJson(value);
  //           _chats.add(chatCopy.toJson());
  //         }
  //       });
  //       setStateIfMounted(_chats);
  //     });
  //   });
  // }

  Future<void> _loadChatsForMember() async {
     final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final _chats = <Map<dynamic, dynamic>>[];
    final memberQuery = memberDao
        .getMemberQuery()
        .orderByChild(authProvider.username)
        .equalTo(true);
    final DatabaseEvent memberSnapshot = await memberQuery.once();
    if (memberSnapshot.snapshot.value == null) {
      return;
    }

    final json = memberSnapshot.snapshot.value as Map<dynamic, dynamic>;
    final memberChatsIds = json.keys.toList();

    final chatQuery = chatDao.getChatQuery();
    final chatSnapshot = await chatQuery.once();
    final chatJson = chatSnapshot.snapshot.value as Map<dynamic, dynamic>;
    chatJson.forEach((key, value) {
      if (memberChatsIds.contains(key)) {
        Chat chatCopy = Chat.fromJson(value);
        _chats.add(chatCopy.toJson());
      }
    });
    setStateIfMounted(_chats);

    for (final chat in chats) {
      _listenForChatUpdates(chat['id']);
    }
  }

  void _listenForChatUpdates(String chatId) {
    final chatRef = database.child('chats/$chatId');
    chatRef.onValue.listen((event) {
      final chatIndex = chats.indexWhere((chat) => chat['id'] == chatId);
      if (chatIndex != -1) {
        setState(() {
          chats[chatIndex] = event.snapshot.value as Map<dynamic, dynamic>;
        });
      }
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
     final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      bottomNavigationBar: const AppBarBack(),
      backgroundColor: Globals.backgroundColor,
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Column(
        children: [
          if (chats.isEmpty)
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.8),
                const Center(
                  child: Text(
                    'No chats yet',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (BuildContext context, int index) {
                  final conversation = chats[index];
                  return ListTile(
                    title: Text(
                      conversation['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      conversation['lastMessage'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    leading: CircleAvatar(
                      child: Text(
                        conversation['title'][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatConversationScreen(
                            chat: Chat.fromJson(conversation),
                            auth: authProvider,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
