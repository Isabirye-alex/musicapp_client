import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';
import 'package:little_music/utilis/custom_text_field.dart';
import 'package:little_music/utilis/loader.dart';

class ProfileEditMode extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final VoidCallback onSave;
  final VoidCallback onLogout;

  const ProfileEditMode({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.onSave,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authViewmodelProvider.select((val) => val?.isLoading == true),
    );

    return isLoading
        ? Loader()
        : Form(
            key: formKey,
            child: ListView(
              children: [
                CustomTextField(
                  controller: firstNameController,
                  hintText: "First Name",
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: lastNameController,
                  hintText: "Last Name",
                ),
                SizedBox(height: 10),
                CustomTextField(controller: emailController, hintText: "Email"),
                SizedBox(height: 20),
                ElevatedButton(onPressed: onSave, child: Text("Save Changes")),
                SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text("Log Out"),
                ),
              ],
            ),
          );
  }
}
