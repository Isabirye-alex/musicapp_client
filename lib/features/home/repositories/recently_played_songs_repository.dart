import 'dart:convert';

import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:http/http.dart' as http;

class RecentlyPlayedSongsRepository {
  Future<Either<AppFailure, RemoteSongModel>> addToRecentlyPlayed(
    String? authToken,
    String? songId,
  ) async {
    try {
      final String url =
          '${ServerConstants.serverUrl}/api/v1/songs/recent/new?sond_id=$songId';
      final request = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': authToken ?? '',
        },
      );

      if (request.statusCode == 200) {
        final result = jsonDecode(request.body);
        return Right(result);
      } else {
        final result = jsonDecode(request.body);
        return Left(
          AppFailure(message: result['detail'] ?? 'Unexpected error occured'),
        );
      }
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
