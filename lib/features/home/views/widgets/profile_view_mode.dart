import 'package:flutter/material.dart';
import 'package:little_music/features/home/views/widgets/profile_avatar.dart';
import 'package:little_music/features/home/views/widgets/profile_info_card.dart';

class ProfileViewMode extends StatelessWidget {
  final dynamic user;
  final VoidCallback onLogout;

  const ProfileViewMode({
    super.key,
    required this.user,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(user: user),
        const SizedBox(height: 16),

        Text(
          '${user.firstName} ${user.lastName}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        Text(user.email),

        const SizedBox(height: 24),

        ProfileInfoCard(
          icon: Icons.person,
          label: "First Name",
          value: user.firstName,
        ),
        ProfileInfoCard(
          icon: Icons.person_outline,
          label: "Last Name",
          value: user.lastName,
        ),
        ProfileInfoCard(icon: Icons.email, label: "Email", value: user.email),
        ProfileInfoCard(
          icon: Icons.fingerprint,
          label: "User ID",
          value: user.id,
        ),

        const SizedBox(height: 24),

        OutlinedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text("Log Out", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
