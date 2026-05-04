import 'dart:convert';

import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recently_played_songs_repository.g.dart';

@Riverpod(keepAlive: true)
RecentlyPlayedSongsRepository recentlyPlayedSongsRespostory(Ref ref) {
  return RecentlyPlayedSongsRepository();
}

class RecentlyPlayedSongsRepository {
  Future<Either<AppFailure, RemoteSongModel?>> addToRecentlyPlayed(
    String? authToken,
    String? songId,
  ) async {
    try {
      final String url =
          '${ServerConstants.serverUrl}/api/v1/songs/recent/new/?song_id=$songId';

      final request = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': authToken ?? '',
        },
      );

      if (request.statusCode == 201) {
        final result = jsonDecode(request.body);

        // Parse the response to RemoteSongModel
        final song = RemoteSongModel.fromJson(result as Map<String, dynamic>);
        return Right(song);
      } else {
        final result = jsonDecode(request.body);
        return Left(
          AppFailure(message: result['detail'] ?? 'Unexpected error occurred'),
        );
      }
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<RemoteSongModel>>> getRecentlyPlayedSongs(
    String? authToken,
    int limit,
    int offset,
  ) async {
    try {
      final String url =
          '${ServerConstants.serverUrl}/api/v1/songs/recent/page/?limit=$limit&offset=$offset';
      final request = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': authToken ?? '',
        },
      );

      if (request.statusCode == 200) {
        final response = jsonDecode(request.body) as List<dynamic>;
        final List<RemoteSongModel> songs = response
            .map<RemoteSongModel>(
              (s) => RemoteSongModel.fromJson(s as Map<String, dynamic>),
            )
            .toList();
        return Right(songs);
      } else {
        final response = jsonDecode(request.body);
        return Left(
          AppFailure(
            message: response['detail'] ?? 'Un expexted error occured',
          ),
        );
      }
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
