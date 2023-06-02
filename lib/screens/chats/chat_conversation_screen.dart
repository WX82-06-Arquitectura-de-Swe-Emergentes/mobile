import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chatDao.dart';
import 'package:frontend/firebase/member/memberDao.dart';
import 'package:frontend/firebase/message/message.dart';
import 'package:frontend/firebase/message/messageDao.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:intl/intl.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen(
      {Key? key, required this.chat, required this.auth})
      : super(key: key);
  final Chat chat;
  final AuthenticationProvider auth;

  @override
  // ignore: library_private_types_in_public_api
  _ChatConversationScreenState createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();
  final chatDao = ChatDao();
  final memberDao = MemberDao();
  final messageDao = MessageDao();
  late dynamic messages;

  Future<void> _loadMessagesFromChat() async {
    Query query = FirebaseDatabase.instance
        .ref()
        .child('messages')
        .orderByChild('timestamp');

    query.onValue.listen((DatabaseEvent event) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;

      var _messages = {};
      dynamic sortedMessages;
      if (json.containsKey(widget.chat.id)) {
        _messages = json[widget.chat.id] as Map<dynamic, dynamic>;
        setStateIfMounted(_messages.values.toList()
          ..sort((a, b) => a['timestamp'].compareTo(b['timestamp'])));
      } else {
        setStateIfMounted(_messages);
      }
    });
  }

  void setStateIfMounted(f) {
    if (mounted) {
      setState(() {
        messages = f;
      });
    }
  }

  String formatTimestampToHour(int timestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('HH:mm');
    return formatter.format(dateTime.subtract(const Duration(hours: 5)));
  }

  @override
  void initState() {
    super.initState();
    messages = [];
    _loadMessagesFromChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(
        title: Text("Travel Package - ${widget.chat.title}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final messageData = messages[index];
                final name = messageData['name'] as String;
                final messageText = messageData['message'] as String;
                final timestamp =
                    formatTimestampToHour(messageData['timestamp'] as int);
                final isMe = name == widget.auth.username;

                return Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.grey[300] : Colors.blue[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${isMe ? 'Me' : name} - ${timestamp.toString()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            messageText,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final messageText = _textController.text.trim();
                    if (messageText.isNotEmpty) {
                      Message message = Message(
                        name: widget.auth.username,
                        message: messageText,
                        timestamp: DateTime.now().millisecondsSinceEpoch,
                      );
                      messageDao.saveMessage(widget.chat.id, message);
                      _textController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
