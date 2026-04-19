// lib/features/local_songs/repositories/local_songs_repository.dart

import 'package:little_music/features/home/models/local_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'local_songs_repository.g.dart';

@riverpod
LocalSongsRepository localSongsRepository(Ref ref) {
  return LocalSongsRepository();
}

class LocalSongsRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<LocalSongModel>> fetchDeviceSongs() async {
    final status = await Permission.audio.request();
    if (!status.isGranted) return [];

    final songs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    return songs
        .where((s) => s.isMusic ?? false)
        .map(
          (s) => LocalSongModel(
            id: s.id.toString(),
            title: s.title,
            artist: s.artist ?? 'Unknown Artist',
            path: s.data,
            duration: s.duration ?? 0,
          ),
        )
        .toList();
  }
}
