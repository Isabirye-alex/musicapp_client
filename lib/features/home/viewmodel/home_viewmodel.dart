import 'dart:io';

import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/home/models/song_model.dart';
import 'package:little_music/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(authLocalRepositoryProvider).getToken();
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .fetchAllUserSongs(token!);
  final val = switch (res) {
    Right(value: final r) => r,
    Left(value: final l) => throw l.message,
  };
  return val;
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRemoteRepository _homeRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<List<SongModel>> build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
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
    state = AsyncValue.loading();
    final res = await _homeRemoteRepository.uploadSong(
      song,
      thumbnail,
      songName,
      artistName,
      hexCode,
      token!,
    );
    switch (res) {
      case Right():
        state = const AsyncValue.data([]); //
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }

  // Future<void> getUserSongs() async {
  //   final token = _authLocalRepository.getToken();
  //   state = AsyncLoading();
  //   final response = await _homeRemoteRepository.fetchAllUserSongs(token!);

  //   final val = switch (response) {
  //     Right(value: final List<SongModel> r) => state = AsyncValue.data(r),

  //     Left(value: final l) => state = AsyncValue.error(
  //       l.message,
  //       StackTrace.current,
  //     ),
  //   };
  // }
}
