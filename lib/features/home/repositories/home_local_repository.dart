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
      songs.add(SongModel.fromJson(box.get(k)));
    }
    return songs;
  }
}
