import 'package:fpdart/fpdart.dart' hide State;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:little_music/core/cache/cache_service.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/core/providers/network_notifier.dart';
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
  final _cache = CacheService();

  @override
  AsyncValue<UserModel?>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<String?> signup(
      String firstName,
      String lastName,
      String email,
      String password,
      ) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      firstName,
      lastName,
      email,
      password,
    );
    switch (res) {
      case Right():
        state = AsyncValue.data(null);
      case Left(value: final l):
        state = AsyncValue.error(
        l.message,
        StackTrace.current,
      );
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signIn(email, password);
     switch (res) {
      case Right(value: final r) :
         state = _logInSuccess(r);
      case Left(value: final l) :
         state = AsyncValue.error(
        l.message,
        StackTrace.current,
      );
    }
  }

  Future<UserModel?> getData() async {
    final token = _authLocalRepository.getToken();
    if (token == null) return null;

    final isConnected = ref.read(networkProvider);

    // ── Offline: serve cached user ──
    if (!isConnected) {
      final cached = _cache.getCachedUser();
      if (cached != null) {
        _currentUserNotifier.addUser(cached);
        state = AsyncValue.data(cached);
        return cached;
      }
      return null;
    }

    // ── Online: fetch fresh user ──
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

  AsyncValue<UserModel?> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    _cache.cacheUser(user); // ← cache on every fresh fetch
    return state = AsyncValue.data(user);
  }

  AsyncValue<UserModel?>? _logInSuccess(UserModel user) {
    _authLocalRepository.setToken(user.accessToken);
    _currentUserNotifier.addUser(user);
    _cache.cacheUser(user); // ← cache on login
    return state = AsyncValue.data(user);
  }

  Future<void> updateUser(
      String? firstName,
      String? lastName,
      String? email,
      ) async {
    final token = _authLocalRepository.getToken();
    if (token == null) {
      state = AsyncValue.error('No token found', StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final response = await _authRemoteRepository.updateUserProfile(
      firstName!,
      lastName!,
      email!,
      token,
    );

    switch (response) {
      case Right(value: final r):
        _currentUserNotifier.addUser(r);
        _cache.cacheUser(r); // ← keep cache in sync after update
        state = AsyncValue.data(r);
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
        '1092902676236-4u9pkisorpfv95drcrhqii9rgr1lq7rj.apps.googleusercontent.com',
      );

      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final idToken = account.authentication.idToken;

      if (idToken == null) {
        state = AsyncValue.error('Could not get ID token', StackTrace.current);
        return;
      }

      final res = await _authRemoteRepository.googleSignIn(idToken);

      switch (res) {
        case Right(value: final r):
          state = _logInSuccess(r); // ← _logInSuccess already caches
        case Left(value: final l):
          state = AsyncValue.error(l.message, StackTrace.current);
      }
    } catch (e) {
      final message = e.toString().contains('reauth') || e.toString().contains('canceled')
          ? 'Google Sign-In failed. Please try again.'
          : e.toString();
      state = AsyncValue.error(message, StackTrace.current);
    }
  }
}