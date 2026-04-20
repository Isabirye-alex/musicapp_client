import 'package:flutter/material.dart';
import 'package:little_music/utilis/custom_text_field.dart';

class ProfileEditMode extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;

  final bool showChangePassword;
  final VoidCallback onToggleChangePassword;
  final VoidCallback onSave;
  final VoidCallback onLogout;

  const ProfileEditMode({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.showChangePassword,
    required this.onToggleChangePassword,
    required this.onSave,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          CustomTextField(
            controller: firstNameController,
            hintText: "First Name",
          ),
          CustomTextField(
            controller: lastNameController,
            hintText: "Last Name",
          ),
          CustomTextField(controller: emailController, hintText: "Email"),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: onToggleChangePassword,
            child: Text(
              "Change Password",
              style: TextStyle(color: Colors.purple),
            ),
          ),

          if (showChangePassword) ...[
            CustomTextField(
              controller: currentPasswordController,
              hintText: "Current Password",
            ),
            CustomTextField(
              controller: newPasswordController,
              hintText: "New Password",
            ),
          ],

          const SizedBox(height: 20),

          ElevatedButton(onPressed: onSave, child: const Text("Save Changes")),

          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
