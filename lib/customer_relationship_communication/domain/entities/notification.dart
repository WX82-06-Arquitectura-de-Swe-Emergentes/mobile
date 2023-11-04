class PushNotificationRequest {
  final CustomNotification notification;
  final Object? data;
  final String to;

  PushNotificationRequest({
    required this.notification,
    required this.data,
    required this.to,
  });
}

class CustomNotification {
  final String title;
  final String body;

  CustomNotification({
    required this.title,
    required this.body,
  });

  factory CustomNotification.fromJson(Map<String, dynamic> json) =>
      CustomNotification(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
