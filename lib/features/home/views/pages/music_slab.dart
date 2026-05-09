import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/core/widgets/play_pause_button.dart';
import 'package:little_music/features/home/views/pages/music_player.dart';
import 'package:little_music/utilis/color_converter.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.watch(currentSongProvider.notifier);

    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MusicPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final tween = Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn));
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hexCode),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Hero(
                        tag: 'music-image',
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            currentSong.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(CupertinoIcons.music_note),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: AColorTheme.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              currentSong.displayArtist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: AColorTheme.subtitleText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => songNotifier.previousSong(),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AColorTheme.gradient1,
                            ),
                            child: Center(
                              child: Icon(Icons.skip_previous, size: 20),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        PlayPauseButton(songNotifier: songNotifier),
                        SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => songNotifier.nextSong(),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AColorTheme.gradient1,
                            ),
                            child: Center(
                              child: Icon(Icons.skip_next, size: 20),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration =
                  songNotifier.audioPlayer?.duration ?? Duration.zero;
              double progress = 0.0;

              if (duration.inMilliseconds > 0) {
                progress = position.inMilliseconds / duration.inMilliseconds;
              }

              return Positioned(
                bottom: 0,
                left: 12,
                right: 12,
                child: SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: AColorTheme.gradient1.withAlpha(50),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AColorTheme.gradient1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
