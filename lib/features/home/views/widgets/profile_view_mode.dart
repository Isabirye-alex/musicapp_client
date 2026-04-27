import 'package:flutter/material.dart';
import 'package:little_music/features/home/views/widgets/profile_avatar.dart';
import 'package:little_music/features/home/views/widgets/profile_info_card.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/utilis/date_formatter.dart';

class ProfileViewMode extends StatelessWidget {
  final User user;
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

        Text(user.email, style: Theme.of(context).textTheme.bodyMedium),

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
        ProfileInfoCard(
          icon: Icons.timelapse_sharp,
          label: "Joined",
          value: user.joinedAt?.toReadableFull() ?? 'N/A',
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
