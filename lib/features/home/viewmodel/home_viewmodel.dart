import 'dart:io';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/cache/cache_service.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/providers/network_notifier.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/repositories/home_local_repository.dart';
import 'package:little_music/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

enum SongSortOrder { newest, oldest, name }

@Riverpod(keepAlive: true)
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRemoteRepository _homeRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late HomeLocalRepository _homeLocalRepository;
  final _cache = CacheService();
  bool _hasMore = true;
  SongSortOrder _sortOrder = SongSortOrder.newest;
  String? _search;                                        // ← track active search

  bool get hasMore => _hasMore && ref.read(networkProvider);
  SongSortOrder get sortOrder => _sortOrder;
  String? get search => _search;

  @override
  AsyncValue<List<RemoteSongModel>> build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return const AsyncValue.loading();
  }

  Future<void> fetchNextPage({String? search}) async {
    if (!_hasMore) return;

    final isConnected = ref.read(networkProvider);

    if (!isConnected) {
      final cached = _cache.getCachedSongs();
      _hasMore = false;
      state = cached.isNotEmpty
          ? AsyncValue.data(cached)
          : AsyncValue.error('No internet connection', StackTrace.current);
      return;
    }

    final currentSongs = state.value ?? [];
    final nextPage = currentSongs.length ~/ 80;        
    final token = _authLocalRepository.getToken();

    final res = await _homeRemoteRepository.fetchAllPlatformSongs(
      token,
      80,
      nextPage * 80,
      sortOrder: _sortOrder.name,
      search: search ?? _search, 
    );

    switch (res) {
      case Right(value: final newSongs):
        if (newSongs.length < 80) _hasMore = false;       
        final updated = [...currentSongs, ...newSongs];
        state = AsyncValue.data(updated);
        _cache.cacheSongs(updated);
      case Left(value: final l):
        _hasMore = false;
        final cached = _cache.getCachedSongs();
        state = cached.isNotEmpty
            ? AsyncValue.data(cached)
            : AsyncValue.error(l.message, StackTrace.current);
    }
  }

  Future<void> refresh({String? search}) async {
    _hasMore = true;

    final isConnected = ref.read(networkProvider);

    if (!isConnected) {
      final cached = _cache.getCachedSongs();
      state = cached.isNotEmpty
          ? AsyncValue.data(cached)
          : AsyncValue.error('No internet connection', StackTrace.current);
      return;
    }

    final token = _authLocalRepository.getToken();
    final res = await _homeRemoteRepository.fetchAllPlatformSongs(
      token,
      80,
      0,
      sortOrder: _sortOrder.name,
      search: search ?? _search,
    );

    switch (res) {
      case Right(value: final newSongs):
        if (newSongs.length < 80) _hasMore = false;
        state = AsyncValue.data(newSongs);
        _cache.cacheSongs(newSongs);
      case Left(value: final l):
        _hasMore = false;
        final cached = _cache.getCachedSongs();
        state = cached.isNotEmpty
            ? AsyncValue.data(cached)
            : AsyncValue.error(l.message, StackTrace.current);
    }
  }

  // entry point
  Future<void> searchSongs(String? query) async {
    final trimmed = (query ?? '').trim();
    _search = trimmed.isEmpty ? null : trimmed;       
    await refresh(search: _search);
  }

  Future<void> clearSearch() async {
    _search = null;
    await refresh();
  }


  Future<void> changeSortOrder(SongSortOrder order) async {
    if (_sortOrder == order) return;
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
        await refresh();
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

    ref.read(currentSongProvider.notifier).updateFavoriteStatus(!currentSong.isFavorite);

    final res = await _homeRemoteRepository.toggleFavorite(
      currentSong.id,
      token,
    );

    switch (res) {
      case Left(value: final l):
        ref.read(currentSongProvider.notifier).updateFavoriteStatus(currentSong.isFavorite);
        state = AsyncValue.error(l.message, StackTrace.current);
      case Right(value: final isFavorite):
        ref.read(currentSongProvider.notifier).updateFavoriteStatus(isFavorite);
    }
  }
}