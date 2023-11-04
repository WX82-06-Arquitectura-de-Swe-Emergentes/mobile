class Message {
  Message({
    required this.name,
    required this.message,
    required this.timestamp,
  });

  final String name;
  final String message;
  final int timestamp;

  String get getName => name;
  String get getMessage => message;
  int get getTimestamp => timestamp;
}
