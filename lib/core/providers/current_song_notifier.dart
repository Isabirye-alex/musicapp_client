import 'dart:async';
import 'dart:typed_data';

import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  StreamSubscription? _playerStateSubscription;
  bool isPlaying = false;
  AudioPlayer? audioPlayer;

  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<LocalSongModel> deviceSongs = [];

  @override
  SongsModel? build() {
    return null;
  }

  // Permission

  Future<bool> requestPermission() async {
    return await _audioQuery.permissionsRequest();
  }

  //Device song queries

  Future<List<LocalSongModel>> fetchDeviceSongs({
    SongSortType sortType = SongSortType.TITLE,
    OrderType orderType = OrderType.ASC_OR_SMALLER,
    int minDuration = 30000,
  }) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      throw Exception('Storage permission denied. Cannot query device songs.');
    }

    final rawSongs = await _audioQuery.querySongs(
      sortType: sortType,
      orderType: orderType,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    deviceSongs = rawSongs
        .where((s) => (s.duration ?? 0) >= minDuration && s.uri != null)
        .map((s) => LocalSongModel.fromAudioQuery(s))  // ← uses factory
        .toList();

    return deviceSongs;
  }

  Future<List<LocalSongModel>> fetchSongsByAlbum(String album) async {
    if (deviceSongs.isEmpty) await fetchDeviceSongs();
    return deviceSongs
        .where((s) => s.album.toLowerCase() == album.toLowerCase())
        .toList();
  }

  Future<List<LocalSongModel>> fetchSongsByArtist(String artist) async {
    if (deviceSongs.isEmpty) await fetchDeviceSongs();
    return deviceSongs
        .where((s) => s.artist.toLowerCase() == artist.toLowerCase())
        .toList();
  }

  Future<List<LocalSongModel>> searchSongs(String query) async {
    if (deviceSongs.isEmpty) await fetchDeviceSongs();
    final q = query.toLowerCase();
    return deviceSongs
        .where((s) =>
    s.title.toLowerCase().contains(q) ||
        s.artist.toLowerCase().contains(q))
        .toList();
  }

  /// Uses [albumId] from [LocalSongModel] for accurate artwork lookup.
  /// Falls back to song id if albumId is null.
  Future<Uint8List?> fetchArtwork(LocalSongModel song) async {
    return await _audioQuery.queryArtwork(
      song.albumId ?? int.parse(song.id),
      ArtworkType.ALBUM,
      quality: 100,
      size: 500,
    );
  }

  void updateSong(SongsModel song) async {
    _playerStateSubscription?.cancel();
    await audioPlayer?.dispose();
    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.audioPath));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.play();

    state = song;
    isPlaying = true;

    _playerStateSubscription = audioPlayer!.playerStateStream.listen((playerState) {
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

  void updateFavoriteStatus(bool isFavorite) {
    final current = state;
    if (current is RemoteSongModel) {
      state = current.copyWith(isFavorite: isFavorite);
    }
  }
}