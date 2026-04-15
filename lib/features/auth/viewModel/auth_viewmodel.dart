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

  Future<void> signup(String firstName, String lastName, String email, String password) async {
    await _authRemoteRepository.signup(firstName, lastName, email, password);
    
  }
}
