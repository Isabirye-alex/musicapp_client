import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/features/auth/repositories/auth_local_repository.dart';
import 'package:little_music/features/auth/view/pages/login_page.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/login_prompt.dart';
import 'package:little_music/features/home/views/widgets/profile_edit_mode.dart';
import 'package:little_music/features/home/views/widgets/profile_view_mode.dart';
import 'package:little_music/utilis/loader.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isEditMode = false;
  bool showChangePassword = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider)?.user;

    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isLoading = ref.watch(
      authViewmodelProvider.select((val) => val?.isLoading == true),
    );

    if (currentUser == null) {
      return const LoginPrompt();
    }

    return Scaffold(
      appBar: _buildAppBar(currentUser),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: isEditMode
                  ? ProfileEditMode(
                      formKey: formKey,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      emailController: emailController,
                      currentPasswordController: currentPasswordController,
                      newPasswordController: newPasswordController,
                      showChangePassword: showChangePassword,
                      onToggleChangePassword: () {
                        setState(() {
                          showChangePassword = !showChangePassword;
                        });
                      },
                      onSave: _saveProfile,
                      onLogout: _logout,
                    )
                  : ProfileViewMode(user: currentUser.user, onLogout: _logout),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(currentUser) {
    return AppBar(
      title: const Text('Profile'),
      actions: [
        if (!isEditMode)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => setState(() => isEditMode = true),
          )
        else
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() {
              isEditMode = false;
              showChangePassword = false;
            }),
          ),
      ],
    );
  }

  void _saveProfile() {
    if (formKey.currentState!.validate()) {
      // call API later
      setState(() => isEditMode = false);
    }
  }

  void _logout() {
    ref.read(authLocalRepositoryProvider).clearToken();
    ref.read(currentUserProvider.notifier).removeUser();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }
}
