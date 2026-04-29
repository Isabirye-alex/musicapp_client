
import 'package:little_music/core/repositories/token_repository.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_register_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class TokenRegisterViewmodel extends _$TokenRegisterViewmodel {
  late final TokenRepository _tokenRepository;
  late final AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<bool> build() {
    _tokenRepository = ref.read(tokenRepositoryProvider);
    _authLocalRepository = ref.read(authLocalRepositoryProvider);

    return const AsyncValue.data(false); // ok but optional
  }

  Future<void> registerToken(String token, String platform) async {
    final authToken = _authLocalRepository.getToken();

    state = const AsyncValue.loading();

    final result = await _tokenRepository.registerDeviceToken(
      token,
      platform,
      authToken,
    );

    result.match(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (success) {
        state = AsyncValue.data(success);
      },
    );
  }
}