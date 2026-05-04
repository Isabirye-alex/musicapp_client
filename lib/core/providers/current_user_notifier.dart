// Current user state management
// Handles the currently logged-in user state
import 'package:little_music/core/cache/cache_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/model/user_model.dart';
part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  final cacheService = CacheService();
  @override
  UserModel? build() {
    return null;
  }

  /// Adds a user to the state (when user logs in)
  /// [user] - The user model to set as current user
  void addUser(UserModel user) {
    state = user;
  }

  /// Removes the user from state (when user logs out)
  void removeUser() {
    cacheService.clearAll();
    state = null;
  }
}
