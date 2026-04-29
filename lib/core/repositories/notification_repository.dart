import 'dart:convert';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:http/http.dart' as http;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/core/models/notification_payload_model.dart';
import 'package:little_music/core/models/send_to_token_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_repository.g.dart';

@Riverpod()
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository();
}

class NotificationRepository  {

  Future<Either<AppFailure, String>> sendNotificationToToken({
    required String deviceToken,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    try {
      final model = SendToTokenModel(
        token: deviceToken,
        notification: NotificationPayload(
          title: title,
          body: body,
          imageUrl: imageUrl,
        ),
        data: {
          "type": "music_update",
        },
      );

      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/api/v1/notifications/notify/token"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('========================Sucess===================');
        return Right(decoded["message_id"]);
      } else {
        return Left(
          AppFailure(message: response.body),
        );
      }

    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}