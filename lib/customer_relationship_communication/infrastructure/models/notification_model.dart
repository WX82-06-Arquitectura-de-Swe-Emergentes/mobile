import 'package:frontend/customer_relationship_communication/domain/entities/notification.dart';

class PushNotificationRequestModel extends PushNotificationRequest {
  PushNotificationRequestModel(
      {required CustomNotification notification,
      required String data,
      required String to})
      : super(
          notification: notification,
          data: data,
          to: to,
        );

  factory PushNotificationRequestModel.fromJson(Map<String, dynamic> json) =>
      PushNotificationRequestModel(
        notification: CustomNotification.fromJson(json["notification"]),
        data: json["data"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "notification": notification.toJson(),
        "data": data,
        "to": to,
      };
}
