import 'package:little_music/core/models/notification_payload_model.dart';

class SendToTokenModel {
  final String token;
  final NotificationPayload notification;
  final Map<String, dynamic>? data;

  const SendToTokenModel({
    required this.token,
    required this.notification,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "notification": notification.toJson(),
      "data": data,
    };
  }
}