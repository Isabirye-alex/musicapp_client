import 'package:just_audio/just_audio.dart';
import 'package:little_music/features/home/repositories/local_songs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/models/sealed_model_class.dart';
part 'local_song_notifier.g.dart';

@riverpod
class LocalSongsNotifier extends _$LocalSongsNotifier {
  late LocalSongsRepository _localSongsRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  LocalSongModel? currentSong;
  List<LocalSongModel> _songs = [];
  int _currentIndex = -1;

  @override
  AsyncValue<List<LocalSongModel>> build() {
    _localSongsRepository = ref.watch(localSongsRepositoryProvider);
    return const AsyncValue.data([]);
  }

  Future<void> pickAndAddSongs() async {
    final picked = await _localSongsRepository.pickSongs();
    if (picked.isEmpty) return;

    // merge without duplicates
    final existing = _songs.map((s) => s.id).toSet();
    final newSongs = picked.where((s) => !existing.contains(s.id)).toList();
    _songs = [..._songs, ...newSongs];
    state = AsyncValue.data(_songs);
  }

  Future<void> playSong(LocalSongModel song) async {
    _currentIndex = _songs.indexWhere((s) => s.id == song.id);
    await _play(song);
  }

  Future<void> _play(LocalSongModel song) async {
    audioPlayer?.dispose();
    audioPlayer = AudioPlayer();
    await audioPlayer!.setFilePath(song.path);
    audioPlayer!.play();
    currentSong = song;
    isPlaying = true;
    ref.notifyListeners();

    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        nextSong();
      }
    });
  }

  void nextSong() {
    if (_songs.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _songs.length;
    _play(_songs[_currentIndex]);
  }

  void previousSong() {
    if (_songs.isEmpty) return;
    final position = audioPlayer?.position ?? Duration.zero;
    if (position.inSeconds > 3) {
      audioPlayer?.seek(Duration.zero);
      return;
    }
    _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    _play(_songs[_currentIndex]);
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

  bool get hasNext => _currentIndex < _songs.length - 1;
  bool get hasPrevious => _currentIndex > 0;
}