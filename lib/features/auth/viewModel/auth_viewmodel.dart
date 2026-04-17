
import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/current_user_notifier.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel?>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences()async{
    await _authLocalRepository.init();
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
    switch (res) {
      case Right():
        state = const AsyncValue.data(null); //
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signIn(email, password);

    final val = switch (res) {
      Right(value: final r) => state = _logInSuccess(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };
  }

  Future<UserModel?> getData()async {
    final token = _authLocalRepository.getToken();
    print('Printing Token.................: $token');
    if(token != null){
      state = const AsyncLoading();
      final response = await _authRemoteRepository.getCurrentUser(token);
      final val = switch (response) {
        Right(value: final r) => _getDataSuccess(r),
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      };

      return val.value;

    }
    return null;

  }
  
  AsyncValue<UserModel?> _getDataSuccess(UserModel user){
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  AsyncValue<UserModel?>? _logInSuccess(UserModel user){
    _authLocalRepository.setToken(user.accessToken);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
