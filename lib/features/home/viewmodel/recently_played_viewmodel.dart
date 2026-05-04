import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/repositories/recently_played_songs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recently_played_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class RecentlyPlayedViewmodel extends _$RecentlyPlayedViewmodel {
  late AuthLocalRepository _authLocalRepository;
  late RecentlyPlayedSongsRepository _recentlyPlayedSongsRepository;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  @override
  AsyncValue<List<RemoteSongModel>> build() {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _recentlyPlayedSongsRepository = ref.watch(
      recentlyPlayedSongsRespostoryProvider,
    );
    return AsyncValue.data([]);
  }

  Future<Either<AppFailure, RemoteSongModel?>> addToRecentlyPlayed(
    String? songId,
  ) async {
    final authToken = _authLocalRepository.getToken();

    if (authToken == null) {
      return Left(
        AppFailure(message: 'Authorisation required to access this feature'),
      );
    }

    state = const AsyncValue.loading();

    final request = await _recentlyPlayedSongsRepository.addToRecentlyPlayed(
      authToken,
      songId,
    );

    switch (request) {
      case Right(value: final song):
        if (song != null) {
          state = AsyncValue.data([...?state.value, song]);
        }
        return Right(song);
      case Left(value: final failure):
        state = AsyncValue.error(failure.message, StackTrace.current);

        return Left(failure);
    }
  }

  Future<Either<AppFailure, List<RemoteSongModel>>> fetchNextPage() async {
    final authToken = _authLocalRepository.getToken();
    if (authToken == null) {
      return Left(AppFailure(message: 'Sign in to access this page'));
    }
    state = const AsyncValue.loading();
    final currentSongs = state.value ?? [];
    final offset = currentSongs.length;
    final int limit = 100;

    final res = await _recentlyPlayedSongsRepository.getRecentlyPlayedSongs(
      authToken,
      limit,
      offset,
    );
    switch (res) {
      case Right(value: final songs):
        if (songs.length < 80) _hasMore = false;
        final updated = [...currentSongs, ...songs];
        state = AsyncValue.data(updated);
        return Right(updated);
      case Left(value: final failure):
        _hasMore = false;
        state = AsyncValue.error(failure.message, StackTrace.current);
        return Left(failure);
    }
  }
}
