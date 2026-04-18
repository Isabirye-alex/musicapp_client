import 'dart:async';

import 'package:little_music/features/home/models/song_model.dart';
import 'package:little_music/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  StreamSubscription? _playerStateSubscription;
  late HomeLocalRepository _homeLocalRepository;
  bool isPlaying = false;
  AudioPlayer? audioPlayer;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel? song) async {
    _playerStateSubscription?.cancel();
    audioPlayer?.dispose();
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song!.song));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.play();
    state = song;
    _homeLocalRepository.uploadLocalSongs(song);
    isPlaying = true;

    // Listen for song completion
    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer?.pause();
        isPlaying = false;
        ref.notifyListeners();
      }
    });
  }

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

  void seek(double value) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
