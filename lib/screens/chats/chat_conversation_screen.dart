import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  final dynamic chat;
  final AuthenticationProvider auth;

  @override
  State<ChatConversationScreen> createState() {
    return _ChatConversationScreenState();
  }
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

  void sendMessage() {
    final messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      Message newMessage = Message(
        name: widget.auth.username,
        message: messageText,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      messageDao.saveMessage(widget.chat.id, newMessage);
      DatabaseReference chatRef =
          FirebaseDatabase.instance.ref().child('chats');

      chatRef.child(widget.chat.id).update({
        "lastMessage": newMessage.message,
        "timestamp": newMessage.timestamp,
      });

      _textController.clear();
    }
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
      appBar: AppBar(
        title: Text("${widget.chat.title} chat"),
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
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Globals.primaryColor : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 5 : 20),
                          topRight: Radius.circular(isMe ? 20 : 5),
                          bottomLeft: const Radius.circular(20),
                          bottomRight: const Radius.circular(20),
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 50,
                        maxWidth: 200,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (!isMe)
                                const Icon(
                                  Icons.account_circle,
                                  size: 20,
                                ),
                              Text(
                                isMe ? 'Me' : name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                            ),
                            child: Text(
                              messageText,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            timestamp,
                            style: TextStyle(
                              fontSize: 12,
                              color: isMe ? Colors.white : Colors.black,
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
                    sendMessage();
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
