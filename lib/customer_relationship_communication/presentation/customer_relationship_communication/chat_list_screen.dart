// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/widgets/app_bar.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/database/realtime/realtime_database_service.dart';
import 'package:frontend/customer_relationship_communication/presentation/customer_relationship_communication/chat_conversation_screen.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() {
    return _ChatListScreenState();
  }
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<Map<dynamic, dynamic>> chats = [];
  late RealtimeDatabaseService realtimeDatabaseService;
  late IdentityAccessManagementApi authProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    realtimeDatabaseService = RealtimeDatabaseService();
    authProvider = Provider.of<IdentityAccessManagementApi>(
      context,
      listen: false,
    );

    realtimeDatabaseService
        .loadChatsForMember(authProvider.username)
        .then((value) {
      chats = value;

      for (final chat in chats) {
        _listenForChatUpdates(chat['id']);
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  void _listenForChatUpdates(String chatId) {
    final chatRef = realtimeDatabaseService.database.child('chats/$chatId');
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
