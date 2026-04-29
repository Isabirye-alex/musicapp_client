import 'dart:convert';

import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/core/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_repository.g.dart';

@Riverpod()
TokenRepository tokenRepository(Ref ref) {
  return TokenRepository();
}

class TokenRepository {


  Future<Either<AppFailure, TokenModel>> resgiterDeviceToken(String? token, String? platform, String? authToken) async {
    try {
      final model = TokenModel(deviceToken: token ?? '', platform: platform ?? '');
      final request = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/api/v1/tokens/fcm/register-token'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': authToken ?? ''},
        body: model.toJson(),
      );
      if (request.statusCode != 200) {
      
        return Left(AppFailure(message: 'Failed to register token: ${request.body}'));
      }
      final responseData = request.body;
      final decoded = jsonDecode(responseData);
      print(decoded);
      return Right(decoded['success']);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}