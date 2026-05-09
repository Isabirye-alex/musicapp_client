
import 'package:flutter/material.dart';

import '../core/providers/current_song_notifier.dart';
import '../core/theme/a_color_theme.dart';

void showVolumeSheet(BuildContext context, CurrentSongNotifier notifier) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xff1e1e1e),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: StatefulBuilder(
        builder: (context, setState) {
          final volume = notifier.audioPlayer?.volume ?? 1.0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volume',
                style: TextTheme.of(context).titleMedium?.copyWith(
                  color: AColorTheme.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.volume_down_rounded, color: Colors.white54),
                  Expanded(
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 1,
                      activeColor: AColorTheme.whiteColor,
                      inactiveColor: AColorTheme.whiteColor.withAlpha(60),
                      onChanged: (val) {
                        setState(() {});
                        notifier.audioPlayer?.setVolume(val);
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up_rounded, color: Colors.white54),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
