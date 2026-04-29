import 'dart:async';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  StreamSubscription? _playerStateSubscription;
  bool isPlaying = false;
  AudioPlayer? audioPlayer;

  @override
  SongsModel? build() {
    return null;
  }

  List<RemoteSongModel> _playlist = [];
  int _currentIndex = -1;

  void setPlaylist(List<RemoteSongModel> songs, {int startIndex = 0}) {
    _playlist = songs;
    _currentIndex = startIndex;
    updateSong(_playlist[_currentIndex]);
  }

  void nextSong() {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % _playlist.length;
    updateSong(_playlist[_currentIndex]);
  }

  void previousSong() {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    updateSong(_playlist[_currentIndex]);
  }

  void updateSong(SongsModel song) async {
    _playerStateSubscription?.cancel();
    await audioPlayer?.dispose();
    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.audioPath),tag: MediaItem(
        id: song.id,
        title: song.displayTitle,
        artist: song.displayArtist,
        artUri: Uri.parse(song.thumbnailUrl),
      ),);
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.play();

    state = song;
    isPlaying = true;

    _playerStateSubscription = audioPlayer!.playerStateStream.listen((
      playerState,
    ) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer?.pause();
        isPlaying = false;
        ref.notifyListeners();
      }
    });
  }

  /// Toggles between play and pause states
  void playAndPause() async {
    if (isPlaying) {
      audioPlayer?.pause();
      isPlaying = false;
    } else {
      audioPlayer?.play();
      isPlaying = true;
    }
    ref.notifyListeners();
  }

  /// Seeks to a specific position in the current song
  /// [value] - Position as a fraction (0.0 to 1.0) of total duration
  void seek(double value) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }

  /// [isFavorite] - Whether the song is marked as favorite
  void updateFavoriteStatus(bool isFavorite) {
    final current = state;
    if (current is RemoteSongModel) {
      state = current.copyWith(isFavorite: isFavorite);
    }
  }
}
