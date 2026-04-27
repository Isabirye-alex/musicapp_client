import 'package:fpdart/fpdart.dart' hide State;
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

/// Riverpod notifier for authentication state management
/// Handles signup, signin, and session persistence
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

  /// Initializes local storage for authentication
  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  /// Registers a new user account
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [email] - User's email address
  /// [password] - User's password
  /// Returns error message on failure, null on success
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

    // Handle Either type result from repository
    final val = switch (res) {
      Right(value: final r) => state = AsyncValue.data(null),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };

    return null;
  }

  /// Authenticates user with email and password
  /// [email] - User's email address
  /// [password] - User's password
  Future<void> signIn(String email, String password) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signIn(email, password);

    // Handle Either type result from repository
    final val = switch (res) {
      Right(value: final r) => state = _logInSuccess(r),
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
    };
  }

  /// Retrieves current user data using stored token
  /// Returns UserModel if authenticated, null otherwise
  Future<UserModel?> getData() async {
    final token = _authLocalRepository.getToken();
    if (token != null) {
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

  /// Handles successful user data retrieval
  /// Updates state and notifies current user provider
  AsyncValue<UserModel?> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  /// Handles successful login
  /// Stores token locally and updates user state
  AsyncValue<UserModel?>? _logInSuccess(UserModel user) {
    _authLocalRepository.setToken(user.accessToken);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
