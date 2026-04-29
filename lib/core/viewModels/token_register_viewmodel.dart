import 'package:little_music/core/models/token_model.dart';
import 'package:little_music/core/repositories/token_repository.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart' hide State;
part 'token_register_viewmodel.g.dart';

@riverpod
class TokenRegisterViewmodel extends _$TokenRegisterViewmodel {
  late final TokenRepository _tokenRepository;
  late final AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<TokenModel?> build() {
    _tokenRepository = ref.watch(tokenRepositoryProvider);
  _authLocalRepository = ref.read(authLocalRepositoryProvider);
    return const AsyncValue.data(null);
  }

  Future<void> registerToken(String? token,  String? platform) async {
    final authToken = ref.watch(authLocalRepositoryProvider).getToken();
    
    state = const AsyncValue.loading();

    final result = await _tokenRepository.resgiterDeviceToken(
      token,
      platform,
      authToken
    );

    final val = switch (result) {
      Right(value: final success) => state = AsyncValue.data(success),
      Left(value: final failure) => state = AsyncValue.error(
        failure.message,
        StackTrace.current,
      ),
    };
  }
}
