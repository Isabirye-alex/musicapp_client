import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/sealed_model_class.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box('songs_box');

  void uploadLocalSongs(RemoteSongModel song) {
    box.put(song.songId, song.toJson());
  }

    List<RemoteSongModel> loadSongs() {
    List<RemoteSongModel> songs = [];

    for (final k in box.keys) {
      final value = box.get(k);
      
      final Map<String, dynamic> songMap = Map<String, dynamic>.from(value);
      songs.add(RemoteSongModel.fromJson(songMap));
    }
    return songs;
  }
}
