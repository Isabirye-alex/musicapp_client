import 'dart:async';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/viewmodel/recently_played_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'network_notifier.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  StreamSubscription? _playerStateSubscription;
  AudioPlayer? audioPlayer;
  ConcatenatingAudioSource? _playlist;

  @override
  SongsModel? build() {
    audioPlayer = AudioPlayer();
    ref.onDispose(() {
      _playerStateSubscription?.cancel();
      audioPlayer?.dispose();
    });
    return null;
  }

  List<RemoteSongModel> _songs = [];
  int _currentIndex = -1;

  // Expose songs list so the queue sheet can read it
  List<RemoteSongModel> get songs => _songs;

  Future<bool> setPlaylist(
      List<RemoteSongModel> songs, {
        int startIndex = 0,
      }) async {
    final isConnected = ref.read(networkProvider);
    if (!isConnected) return false;

    _songs = songs;
    _currentIndex = startIndex;

    _playlist = ConcatenatingAudioSource(
      children: songs
          .map(
            (song) => AudioSource.uri(
          Uri.parse(song.audioPath),
          tag: MediaItem(
            id: song.id,
            title: song.displayTitle,
            artist: song.displayArtist,
            artUri: Uri.parse(song.thumbnailUrl),
          ),
        ),
      )
          .toList(),
    );

    try {
      await audioPlayer!.setAudioSource(_playlist!, initialIndex: startIndex);
      audioPlayer!.play();
    } catch (e) {
      return false;
    }

    state = songs[startIndex];
    await _addToRecentlyPlayed(songs[startIndex]);

    _playerStateSubscription?.cancel();
    _playerStateSubscription = audioPlayer!.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        _currentIndex = index;
        state = _songs[index];
        _addToRecentlyPlayed(_songs[index]);
      }
    });

    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer?.seekToNext();
      }
    });

    return true;
  }

  Future<void> _addToRecentlyPlayed(RemoteSongModel song) async {
    final currentUser = ref.read(currentUserProvider)?.user;
    if (currentUser != null) {
      ref
          .read(recentlyPlayedViewmodelProvider.notifier)
          .addToRecentlyPlayed(song.id);
    }
  }

  void nextSong() => audioPlayer?.seekToNext();

  void previousSong() => audioPlayer?.seekToPrevious();

  void playAndPause() {
    if (audioPlayer?.playing == true) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
  }

  void seek(double value) {
    final duration = audioPlayer?.duration;
    if (duration != null) {
      audioPlayer!.seek(
        Duration(milliseconds: (value * duration.inMilliseconds).toInt()),
      );
    }
  }

  void updateFavoriteStatus(bool isFavorite) {
    final current = state;
    if (current is RemoteSongModel) {
      state = current.copyWith(isFavorite: isFavorite);
    }
  }
  //Repeat
  Future<void> toggleRepeat() async {
    final current = audioPlayer?.loopMode ?? LoopMode.off;
    final next = current == LoopMode.off ? LoopMode.one : LoopMode.off;
    await audioPlayer?.setLoopMode(next);
  }
  //  Shuffle
  Future<void> toggleShuffle() async {
    final current = audioPlayer?.shuffleModeEnabled ?? false;
    await audioPlayer?.setShuffleModeEnabled(!current);

    if (!current) await audioPlayer?.shuffle();
  }
  Future<void> playSpecific(RemoteSongModel song) async {
    final index = _songs.indexWhere((s) => s.id == song.id);
    if (index == -1) return;
    await audioPlayer?.seek(Duration.zero, index: index);
    audioPlayer?.play();
  }
}