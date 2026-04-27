// Local songs state management
// Handles picking, adding, and playing songs from the device
import 'package:just_audio/just_audio.dart';
import 'package:little_music/features/home/repositories/local_songs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/models/sealed_model_class.dart';
part 'local_song_notifier.g.dart';

/// Riverpod notifier for managing locally picked songs
/// Handles song selection, playback, and playlist navigation
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

  /// Opens file picker to select and add songs to the playlist
  /// Filters out duplicates based on song ID
  Future<void> pickAndAddSongs() async {
    final picked = await _localSongsRepository.pickSongs();
    if (picked.isEmpty) return;

    // Merge without duplicates
    final existing = _songs.map((s) => s.id).toSet();
    final newSongs = picked.where((s) => !existing.contains(s.id)).toList();
    _songs = [..._songs, ...newSongs];
    state = AsyncValue.data(_songs);
  }

  /// Plays a specific song from the playlist
  /// [song] - The song to play
  Future<void> playSong(LocalSongModel song) async {
    _currentIndex = _songs.indexWhere((s) => s.id == song.id);
    await _play(song);
  }

  /// Internal method to play a song
  /// Sets up the audio player and starts playback
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

  /// Plays the next song in the playlist
  /// Wraps around to the first song if at the end
  void nextSong() {
    if (_songs.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _songs.length;
    _play(_songs[_currentIndex]);
  }

  /// Plays the previous song in the playlist
  /// If more than 3 seconds into song, restarts current song instead
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

  /// Toggles between play and pause states
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

  /// Whether there is a next song available
  bool get hasNext => _currentIndex < _songs.length - 1;

  /// Whether there is a previous song available
  bool get hasPrevious => _currentIndex > 0;
}
