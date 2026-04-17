import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_remote_repository.g.dart';

@Riverpod()
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {

  Future<void> uploadSong(File song, File thumbnail, String songName, String artistName, String token) async {
    try {
      
      final response = http.MultipartRequest('POST', Uri.parse('${ServerConstants.serverUrl}/songs/upload/'));
      response..files.addAll([
        await http.MultipartFile.fromPath('song', song.path),
        await http.MultipartFile.fromPath('thumbnail', thumbnail.path),
      ])..fields.addAll({
    'song_name': songName,
    'artists_name': artistName
    })..headers.addAll({'x-auth-token': token});

      final result = await response.send();

      if (result.statusCode == 201){
        // final res = jsonDecode(result.);
    }


    }catch (e) {
      rethrow;
    }
    }
  }
