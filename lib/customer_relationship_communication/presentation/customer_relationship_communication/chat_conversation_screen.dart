// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/customer_relationship_communication/domain/entities/notification.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/database/realtime/realtime_database_service.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/notification/fcm/firebase_cloud_messagging_service.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen(
      {Key? key, required this.chatTitle, required this.id})
      : super(key: key);
  final String id;
  final String chatTitle;

  @override
  State<ChatConversationScreen> createState() {
    return _ChatConversationScreenState();
  }
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final RealtimeDatabaseService realtimeDatabaseService =
      RealtimeDatabaseService();
  final FCMService fcmService = FCMService();

  late IdentityAccessManagementApi authProvider;
  late dynamic messages;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<IdentityAccessManagementApi>(
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

  void _loadMessagesFromChat() async {
    Query query = realtimeDatabaseService.database
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

  void _sendNotificationToReceptor() async {
    final String to = await realtimeDatabaseService.findReceptor(
        authProvider.username, widget.id);

    final CustomNotification customNotification = CustomNotification(
      title: 'New message',
      body: 'You have a new message',
    );
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

    await fcmService.sendNotification(payload);
  }

  void _sendMessage() async {
    final messageText = _textController.text.trim();
    String username = authProvider.username;
    String chatId = widget.id;

    if (messageText.isNotEmpty) {
      realtimeDatabaseService.sendMessage(username, chatId, messageText);
      if (widget.chatTitle == "chatbot") {
        print("Enviando mensaje al chatbot");
        _sendChatBotMessage(messageText);
      }
    }
    _textController.clear();
  }

  void _sendChatBotMessage(String currentMessage) async {
    const url = 'https://2fb872mk-5000.brs.devtunnels.ms/message';
    final headers = {'Content-Type': 'application/json'};
    final body = {"chat_id": widget.id, "messages": []};

    List<Map> messages =
        await realtimeDatabaseService.loadChatBotLastMessages(2, widget.id);

    final bodyMessages = [
      ...messages.map((e) => e['message']).toList(),
      currentMessage
    ];
    body['messages'] = bodyMessages;

   await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));
    // final json = jsonDecode(response.body);
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
        title: const Text("Chat"),
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
                              Flexible(
                                child: Text(
                                  isMe ? 'Me' : name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color:
                                          isMe ? Colors.white : Colors.black),
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
