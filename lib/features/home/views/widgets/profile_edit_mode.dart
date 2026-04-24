import 'package:flutter/material.dart';
import 'package:little_music/utilis/custom_text_field.dart';

class ProfileEditMode extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
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
          SizedBox(height: 10,),
          CustomTextField(
            controller: lastNameController,
            hintText: "Last Name",
          ),
          SizedBox(height: 10,),
          CustomTextField(controller: emailController, hintText: "Email"),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: onSave, child: const Text("Save Changes")),

          SizedBox(height: 10,),
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
