import 'package:hive/hive.dart';
import 'package:little_music/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box('songs_box');

  void uploadLocalSongs(SongModel song) {
    box.put(song.songId, song.toJson());
  }

    List<SongModel> loadSongs() {
    List<SongModel> songs = [];

    for (final k in box.keys) {
      final value = box.get(k);
      
      final Map<String, dynamic> songMap = Map<String, dynamic>.from(value);
      songs.add(SongModel.fromJson(songMap));
    }
    return songs;
  }
}
