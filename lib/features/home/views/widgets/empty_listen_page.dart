import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class EmptyStateListen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateListen({
    super.key,
    this.title = 'No recently played songs',
    this.subtitle = 'Play some songs to see them here',
    this.icon = Icons.music_note_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AColorTheme.gradient1.withAlpha(40),
              AColorTheme.gradient2.withAlpha(40),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(30),
              ),
              child: Icon(
                icon,
                size: 32,
                color: AColorTheme.gradient2,
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),

            // ✅ Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}