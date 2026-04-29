import 'dart:io';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/repositories/home_local_repository.dart';
import 'package:little_music/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

enum SongSortOrder { newest, oldest, name }

@Riverpod(keepAlive: true)
Future<List<RemoteSongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(authLocalRepositoryProvider).getToken();
  if (token == null) return [];
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .fetchAllUserSongs(token);
  final val = switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw l.message,
  };
  return val;
}

@Riverpod(keepAlive: true)
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRemoteRepository _homeRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late HomeLocalRepository _homeLocalRepository;
  bool _hasMore = true;
  // ignore: prefer_final_fields
  SongSortOrder _sortOrder = SongSortOrder.newest; //default => newest

  bool get hasMore => _hasMore;
  SongSortOrder get sortOrder => _sortOrder;

  @override
  AsyncValue<List<RemoteSongModel>> build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return AsyncValue.loading();
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;

    final currentSongs = state.value ?? [];
    final nextPage = currentSongs.length ~/ 20;

    final token = _authLocalRepository.getToken();
    final res = await _homeRemoteRepository.fetchAllPlatformSongs(
      token,
      20,
      nextPage * 20,
      sortOrder: _sortOrder.name,
    );

    switch (res) {
      case Right(value: final newSongs):
        if (newSongs.length < 20) {
          _hasMore = false;
        }
        state = AsyncValue.data([...currentSongs, ...newSongs]);
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    _hasMore = true;
    final token = _authLocalRepository.getToken();
    final res = await _homeRemoteRepository.fetchAllPlatformSongs(
      token,
      20,
      0,
      sortOrder: _sortOrder.name,
    );
    switch (res) {
      case Right(value: final newSongs):
        if (newSongs.length < 20) {
          _hasMore = false;
        }
        state = AsyncValue.data(newSongs);
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }

  Future<void> changeSortOrder(SongSortOrder order) async {
    if (_sortOrder == order) {
      return;
    }
    _sortOrder = order;
    await refresh();
  }

  Future<void> upload(
    File song,
    File thumbnail,
    String songName,
    String artistName,
    String hexCode,
  ) async {
    final token = _authLocalRepository.getToken();
    if (token == null) return;
    state = const AsyncValue.loading();
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
        state = const AsyncValue.data([]);
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

    final token = _authLocalRepository.getToken();
    if (token == null) return;

    ref
        .read(currentSongProvider.notifier)
        .updateFavoriteStatus(!currentSong.isFavorite);

    final res = await _homeRemoteRepository.toggleFavorite(
      currentSong.id,
      token,
    );

    switch (res) {
      case Left(value: final l):
        ref
            .read(currentSongProvider.notifier)
            .updateFavoriteStatus(currentSong.isFavorite);
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final r):
        ref
            .read(currentSongProvider.notifier)
            .updateFavoriteStatus(r.isFavorite);
    }
  }
}
