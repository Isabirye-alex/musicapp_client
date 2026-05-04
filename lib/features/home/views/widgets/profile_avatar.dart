import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/model/user_model.dart';

class ProfileAvatar extends StatelessWidget {
  final User user;

  const ProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = user.userAvatar.isNotEmpty;

    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AColorTheme.greyColor,
        child: hasAvatar
            ? ClipOval(
                child: Image.network(
                  user.userAvatar,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      "${user.firstName[0]}${user.lastName[0]}".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              )
            : Text(
                "${user.firstName[0]}${user.lastName[0]}".toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
