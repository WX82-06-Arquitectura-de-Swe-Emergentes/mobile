import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat_dao.dart';
import 'package:frontend/firebase/member/member_dao.dart';
import 'package:frontend/firebase/message/message.dart';
import 'package:frontend/firebase/message/message_dao.dart';
import 'package:frontend/firebase/notification/push_notification_request.dart';
import 'package:frontend/firebase/notification/push_notifications_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/shared/globals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({Key? key, required this.chatTitle, required this.id}) : super(key: key);
  final String id;
  final String chatTitle;

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

  late AuthenticationProvider authProvider;
  late dynamic messages;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    messages = [];
    _loadMessagesFromChat();
  }

  void setStateIfMounted(f) {
    if (mounted) {
      setState(() {
        messages = f;
      });
    }
  }

  // Future<void> _loadMetadataFromChatId() async {
  //   final _chats = <Map<dynamic, dynamic>>[];
  //   final memberQuery = memberDao
  //       .getMemberQuery()
  //       .orderByChild(authProvider.username)
  //       .equalTo(true);
  //   final DatabaseEvent memberSnapshot = await memberQuery.once();
  //   if (memberSnapshot.snapshot.value == null) {
  //     return;
  //   }

  //   final json = memberSnapshot.snapshot.value as Map<dynamic, dynamic>;
  //   final memberChatsIds = json.keys.toList();

  //   final chatQuery = chatDao.getChatQuery();
  //   final chatSnapshot = await chatQuery.once();
  //   final chatJson = chatSnapshot.snapshot.value as Map<dynamic, dynamic>;
  //   chatJson.forEach((key, value) {
  //     if (memberChatsIds.contains(key)) {
  //       Chat chatCopy = Chat.fromJson(value);
  //       _chats.add(chatCopy.toJson());
  //     }
  //   });
  //   if (mounted) {
  //     setState(() {
  //       chats = _chats;
  //     });
  //   }
  //   for (final chat in chats) {
  //     _listenForChatUpdates(chat['id']);
  //   }
  // }

  void _loadMessagesFromChat() async {
    Query query = FirebaseDatabase.instance
        .ref()
        .child('messages')
        .orderByChild('timestamp');

    query.onValue.listen((DatabaseEvent event) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;

      var _messages = {};
      if (json.containsKey(widget.id)) {
        _messages = json[widget.id] as Map<dynamic, dynamic>;
        setStateIfMounted(_messages.values.toList()
          ..sort((a, b) => a['timestamp'].compareTo(b['timestamp'])));
      } else {
        setStateIfMounted(_messages);
      }
    });
  }

  Future<String> _findReceptor(String? chatId) async {
    final emisor = authProvider.username;
    final memberQuery = memberDao.getMemberRef().child(chatId!);
    final memberSnapshot = await memberQuery.once();
    final json = memberSnapshot.snapshot.value as Map<dynamic, dynamic>;
    final receptor = json.keys.toList().firstWhere((key) => key != emisor);
    return receptor;
  }

  void _sendNotificationToReceptor() async {
    final CustomNotification customNotification = CustomNotification(
      title: 'New message',
      body: 'You have a new message',
    );
    final String to = await _findReceptor(widget.id);
    final PushNotificationRequest request = PushNotificationRequest(
      notification: customNotification,
      data: null,
      to: to,
    );

    Map<String, dynamic> payload = {
      "notification": request.notification.toJson(),
      "data": null,
      "to": to,
    };

    await PushNotificationService.sendNotification(payload);
  }

  void _sendMessage() async {
    final messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      Message newMessage = Message(
        name: authProvider.username,
        message: messageText,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      messageDao.saveMessage(widget.id, newMessage);
      DatabaseReference chatRef =
          FirebaseDatabase.instance.ref().child('chats');

      chatRef.child(widget.id).update({
        "lastMessage": newMessage.message,
        "timestamp": newMessage.timestamp,
      });

      _textController.clear();
    }
  }

  String formatTimestampToHour(int timestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('HH:mm');
    return formatter.format(dateTime.subtract(const Duration(hours: 5)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final messageData = messages[index] as Map<dynamic, dynamic>;
                final name = messageData['name'] as String;
                final messageText = messageData['message'] as String;
                final timestamp =
                    formatTimestampToHour(messageData['timestamp'] as int);
                final isMe = name == authProvider.username;

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
                    _sendMessage();
                    _sendNotificationToReceptor();
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
