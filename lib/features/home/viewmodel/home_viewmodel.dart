import 'dart:io';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/repositories/home_local_repository.dart';
import 'package:little_music/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<RemoteSongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(authLocalRepositoryProvider).getToken();
  if (token == null) {
    return [];
  }
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .fetchAllUserSongs(token);
  final val = switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw l.message,
  };
  return val;
}



// Device songs provider
@riverpod
Future<List<LocalSongModel>> getDeviceSongs(Ref ref) async {
  return ref.read(currentSongProvider.notifier).fetchDeviceSongs();
}

@riverpod
Future<List<RemoteSongModel>> getAllPlatformSongs(Ref ref) async {
  final token = ref.watch(authLocalRepositoryProvider).getToken();
  if (token == null){
    return [];
  }
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .fetchAllPlatformSongs(token);

  final val = switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw l.message,
  };
  return val;
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRemoteRepository _homeRemoteRepository;
  // ignore: unused_field
  late AuthLocalRepository _authLocalRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue<List<RemoteSongModel>> build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return AsyncValue.data([]);
  }

  Future<void> upload(
    File song,
    File thumbnail,
    String songName,
    String artistName,
    String hexCode,
  ) async {
    final token = ref.watch(authLocalRepositoryProvider).getToken();
    if (token == null) return;
    state = AsyncValue.loading();
    final res = await _homeRemoteRepository.uploadSong(
      song,
      thumbnail,
      songName,
      artistName,
      hexCode,
      token,
    );
    switch (res) {
      case Right():
        state = const AsyncValue.data([]); //
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }

  List<RemoteSongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> toggleFavorite() async {
    final currentSong = ref.read(currentSongProvider);
    if (currentSong == null || currentSong is! RemoteSongModel) return;

    final token = ref.read(authLocalRepositoryProvider).getToken();
    if (token == null) return;

    ref.read(currentSongProvider.notifier).updateFavoriteStatus(!currentSong.isFavorite);

    final res = await _homeRemoteRepository.toggleFavorite(currentSong.id, token);

    switch (res) {
      case Left(value: final l):

        ref.read(currentSongProvider.notifier).updateFavoriteStatus(currentSong.isFavorite);
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):

        ref.read(currentSongProvider.notifier).updateFavoriteStatus(r.isFavorite);
    }
  }

}
