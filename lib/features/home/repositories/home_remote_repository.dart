import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:http/http.dart' as http;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_remote_repository.g.dart';

@Riverpod()
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {
  Future<Either<AppFailure, SongModel>> uploadSong(
    File song,
    File thumbnail,
    String songName,
    String artistName,
    String hexCode,
    String token,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.serverUrl}/api/v1/songs/upload'),
      );
      request.files.addAll([
        await http.MultipartFile.fromPath('song', song.path),
        await http.MultipartFile.fromPath('thumbnail', thumbnail.path),
      ]);
      request.fields.addAll({
        'song_name': songName,
        'artist_name': artistName,
        'hex_code': hexCode,
      });
      request.headers.addAll({'x-auth-token': token});
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = response.body;
      if (response.statusCode == 201) {
        return Right(SongModel.fromJson(jsonDecode(data)));
      } else {
        return Left(
          AppFailure(
            message: jsonDecode(data)['detail'] ?? 'Error uploading music',
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> fetchAllUserSongs(
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/api/v1/songs/list'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        final List<SongModel> res = result
            .map<SongModel>(
              (s) => SongModel.fromJson(s as Map<String, dynamic>),
            )
            .toList();
        return Right(res);
      } else {
        final result = jsonDecode(response.body);
        return Left(
          AppFailure(message: result['detail'] ?? 'Error fetching user songs'),
        );
      }
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
