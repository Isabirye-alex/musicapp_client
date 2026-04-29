import 'dart:async';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
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

  void setPlaylist(List<RemoteSongModel> songs, {int startIndex = 0}) async {
    _songs = songs;
    _currentIndex = startIndex;

    // build full playlist as ConcatenatingAudioSource
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

    await audioPlayer!.setAudioSource(
      _playlist!,
      initialIndex: startIndex, // start from tapped song
    );
    audioPlayer!.play();

    state = songs[startIndex];
    // listen to index changes to update current song state
    _playerStateSubscription?.cancel();
    _playerStateSubscription = audioPlayer!.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        _currentIndex = index;
        state = _songs[index];
      }
    });
    // handle song completion to auto-advance or stop at end of playlist
    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // audioPlayer?.seek(Duration.zero, index: 0);
        // audioPlayer?.pause();
        audioPlayer?.seekToNext();
      }
    });
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
