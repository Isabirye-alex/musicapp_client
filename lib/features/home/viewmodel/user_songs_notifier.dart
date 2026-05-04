import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/providers/network_notifier.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache/cache_service.dart';
import '../models/sealed_model_class.dart';
import '../repositories/home_remote_repository.dart';
part 'user_songs_notifier.g.dart';
@Riverpod(keepAlive: true)
class UserSongsNotifier extends _$UserSongsNotifier {
  final _cache = CacheService();
  bool _hasMore = true;

  bool get hasMore => _hasMore && ref.read(networkProvider);

  @override
  AsyncValue<List<RemoteSongModel>> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;

    final token = ref.read(authLocalRepositoryProvider).getToken();
    if (token == null) return;

    final isConnected = ref.read(networkProvider);

    //Offline: serve from cache
    if (!isConnected) {
      final cached = _cache.getCachedUserSongs();
      _hasMore = false;
      state = cached.isNotEmpty
          ? AsyncValue.data(cached)
          : AsyncValue.error('No internet connection', StackTrace.current);
      return;
    }

    // ── Online: fetch from API ──
    final currentSongs = state.value ?? [];
    final offset = currentSongs.length;

    final res = await ref
        .read(homeRemoteRepositoryProvider)
        .fetchAllUserSongs(token, 60, offset);

    switch (res) {
      case Right(value: final newSongs):
        if (newSongs.length < 60) _hasMore = false;
        final updated = [...currentSongs, ...newSongs];
        state = AsyncValue.data(updated);
        _cache.cacheUserSongs(updated);
      case Left(value: final l):
        _hasMore = false;
        final cached = _cache.getCachedUserSongs();
        state = cached.isNotEmpty
            ? AsyncValue.data(cached)
            : AsyncValue.error(l.message, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    _hasMore = true;

    final isConnected = ref.read(networkProvider);

    if (!isConnected) {
      final cached = _cache.getCachedUserSongs();
      state = cached.isNotEmpty
          ? AsyncValue.data(cached)
          : AsyncValue.error('No internet connection', StackTrace.current);
      return;
    }

    final token = ref.read(authLocalRepositoryProvider).getToken();
    if (token == null) return;

    final res = await ref
        .read(homeRemoteRepositoryProvider)
        .fetchAllUserSongs(token,  20, 0);

    switch (res) {
      case Right(value: final newSongs):
        if (newSongs.length < 20) _hasMore = false;
        state = AsyncValue.data(newSongs);
        _cache.cacheUserSongs(newSongs);
      case Left(value: final l):
        _hasMore = false;
        final cached = _cache.getCachedUserSongs();
        state = cached.isNotEmpty
            ? AsyncValue.data(cached)
            : AsyncValue.error(l.message, StackTrace.current);
    }
  }
}