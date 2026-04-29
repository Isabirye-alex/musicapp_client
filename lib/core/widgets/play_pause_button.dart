import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.songNotifier,
  });

  final CurrentSongNotifier songNotifier;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: songNotifier.audioPlayer?.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final completed =
            snapshot.data?.processingState == ProcessingState.completed;
           
        final isActuallyPlaying = playing && !completed;
        return GestureDetector(
          onTap: songNotifier.playAndPause,
          child: Container(
            padding: const EdgeInsets.all(2),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AColorTheme.gradient1,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Icon(
                isActuallyPlaying
                    ? Icons.pause_circle_filled_sharp
                    : Icons.play_arrow_outlined,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}
