// ignore_for_file: unused_local_variable

import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/features/auth/repositories/auth_remote_repositry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      firstName,
      lastName,
      email,
      password,
    );
    final val = switch (res) {
      Right(value: final r) => state = AsyncValue.data(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };

  }

   Future<void> signin(
    String email,
    String password,
  ) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signin(
      email,
      password,
    );
    final val = switch (res) {
      Right(value: final r) => state = AsyncValue.data(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };
  }
}
