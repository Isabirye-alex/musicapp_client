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

  Future<bool> setPlaylist(List<RemoteSongModel> songs, {int startIndex = 0}) async {
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
      await audioPlayer!.setAudioSource(
        _playlist!,
        initialIndex: startIndex,
      );
      audioPlayer!.play();
    } catch (e) {
      return false;
    }

    state = songs[startIndex];
    
    //Record the first song when playlist starts
    await _addToRecentlyPlayed(songs[startIndex]);

    _playerStateSubscription?.cancel();
    _playerStateSubscription = audioPlayer!.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        _currentIndex = index;
        state = _songs[index];
        // Record next song
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
    // Get current user (you need to import your user provider)
    // If you don't have a user provider, let me know and I'll help
    final currentUser = ref.read(currentUserProvider)?.user;
    
    // Only add if user is logged in
    if (currentUser != null) {
      // Don't await - let it run in background so it doesn't slow down playback
      ref.read(recentlyPlayedViewmodelProvider.notifier)
          .addToRecentlyPlayed(song.id);
    }
  }

  void nextSong() {
    audioPlayer?.seekToNext();
  }

  void previousSong() {
    audioPlayer?.seekToPrevious();
  }

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
}