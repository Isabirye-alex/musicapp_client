import 'dart:io';

import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/home/models/song_model.dart';
import 'package:little_music/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRemoteRepository _homeRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<SongModel?>? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> upload(
    File song,
    File thumbnail,
    String songName,
    String artistName,
    String hexCode,
  ) async {
    final token = _authLocalRepository.getToken();
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
        state = const AsyncValue.data(null); //
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }
}
