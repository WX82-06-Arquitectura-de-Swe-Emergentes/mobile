class Message {
  final String name;
  final String message;
  final int timestamp;

  Message({
    required this.name,
    required this.message,
    required this.timestamp,
  });

  Message.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        message = json['message'] as String,
        timestamp =  json['timestamp'] as int;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name,
        'message': message,
        'timestamp': timestamp
      };

  // getters
  String get getName => name;
  String get getMessage => message;
  int get getTimestamp => timestamp;

}