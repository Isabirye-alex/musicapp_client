
import 'package:just_audio/just_audio.dart';
import 'package:little_music/features/home/models/local_song_model.dart';
import 'package:little_music/features/home/repositories/local_songs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'local_song_notifier.g.dart';

@riverpod
class LocalSongsNotifier extends _$LocalSongsNotifier {
  late LocalSongsRepository _localSongsRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  LocalSongModel? currentSong;

  @override
  Future<List<LocalSongModel>> build() async {
    _localSongsRepository = ref.watch(localSongsRepositoryProvider);
    return _localSongsRepository.fetchDeviceSongs();
  }

  Future<void> playSong(LocalSongModel song) async {
    audioPlayer?.dispose();
    audioPlayer = AudioPlayer();
    await audioPlayer!.setFilePath(song.path);
    audioPlayer!.play();
    currentSong = song;
    isPlaying = true;
    ref.notifyListeners();

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false;
        ref.notifyListeners();
      }
    });
  }

  void playAndPause() async {
    if (isPlaying) {
      await audioPlayer?.pause();
      isPlaying = false;
    } else {
      await audioPlayer?.play();
      isPlaying = true;
    }
    ref.notifyListeners();
  }
}
