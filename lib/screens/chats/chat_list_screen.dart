// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chat_dao.dart';
import 'package:frontend/firebase/member/member_dao.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/chats/chat_conversation_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() {
    return _ChatListScreenState();
  }
}

class _ChatListScreenState extends State<ChatListScreen> {
  final database = FirebaseDatabase.instance.ref();
  final chatDao = ChatDao();
  final memberDao = MemberDao();
  late List<Map<dynamic, dynamic>> chats;
  late AuthenticationProvider authProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    chats = [];
    _loadChatsForMember().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadChatsForMember() async {
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
    if (mounted) {
      setState(() {
        chats = _chats;
      });
    }
    for (final chat in chats) {
      _listenForChatUpdates(chat['id']);
    }
  }

  void _listenForChatUpdates(String chatId) {
    final chatRef = database.child('chats/$chatId');
    chatRef.onValue.listen((event) {
      final chatIndex = chats.indexWhere((chat) => chat['id'] == chatId);
      if (chatIndex != -1) {
        if (mounted) {
          setState(() {
            chats[chatIndex] = event.snapshot.value as Map<dynamic, dynamic>;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBarBack(),
      backgroundColor: Globals.backgroundColor,
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ))
          else if (chats.isEmpty)
            const Expanded(
                child: Center(
              child: Text(
                'No chats yet',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ))
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
                            chatTitle: conversation['title'],
                            id: conversation['id'],
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
