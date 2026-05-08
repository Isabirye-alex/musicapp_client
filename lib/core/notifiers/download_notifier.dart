import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:little_music/core/services/download_service.dart';
part 'download_notifier.g.dart';

enum DownloadState { idle, downloading, downloaded }

@riverpod
class DownloadNotifier extends _$DownloadNotifier {
  @override
  Map<String, DownloadState> build() => {};

  Future<void> toggle(RemoteSongModel song) async {
    final current = state[song.songId] ?? DownloadState.idle;

    if (current == DownloadState.downloading) return; // already in progress

    final isDownloaded = await DownloadService.isSongDownloaded(song.songId);

    if (isDownloaded) {
      // ── Delete 
      await DownloadService.deleteSong(song.songId);
      state = {...state, song.songId: DownloadState.idle};
    } else {
      // ── Download
      state = {...state, song.songId: DownloadState.downloading};
      final success = await DownloadService.downloadSong(
        songId: song.songId,
        songUrl: song.song,       // ← song.song is the audio URL in your model
        songName: song.songName,
      );
      state = {
        ...state,
        song.songId: success ? DownloadState.downloaded : DownloadState.idle,
      };
    }
  }

  Future<void> syncState(String songId) async {
    final isDownloaded = await DownloadService.isSongDownloaded(songId);
    state = {
      ...state,
      songId: isDownloaded ? DownloadState.downloaded : DownloadState.idle,
    };
  }
}