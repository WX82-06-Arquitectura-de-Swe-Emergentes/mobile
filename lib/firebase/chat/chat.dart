class Chat {
  String id;
  final String title;
  final String lastMessage;
  final int timestamp;

  Chat({
    this.id = "",
    required this.title,
    required this.lastMessage,
    required this.timestamp,
  });

    Chat.fromJson(Map<dynamic, dynamic> json)
        : id = json['id'] as String,
          title = json['title'] as String,
          lastMessage = json['lastMessage'] as String,
          timestamp = json['timestamp'] as int;

    Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
          'id': id,
          'title': title,
          'lastMessage': lastMessage,
          'timestamp': timestamp
        };  }

