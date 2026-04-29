import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/utilis/color_converter.dart';
import 'package:little_music/utilis/time_helper.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.watch(currentSongProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            hexToColor(currentSong!.hexCode),
            const Color(0xff121212),
            const Color(0xff009999),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AColorTheme.transparentColor,
        appBar: AppBar(backgroundColor: AColorTheme.transparentColor),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.displayTitle,
                              style: TextTheme.of(context).bodyLarge?.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              currentSong.displayArtist,
                              style: TextTheme.of(context).bodyLarge?.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: AColorTheme.gradient1,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(homeViewmodelProvider.notifier)
                                .toggleFavorite();
                          },
                          icon: currentSong.favoriteStatus == true
                              ? const Icon(
                                  CupertinoIcons.heart_fill,
                                  color: AColorTheme.accent,
                                  size: 40,
                                )
                              : const Icon(
                                  CupertinoIcons.heart,
                                  color: AColorTheme.gradient1,
                                  size: 40,
                                ),
                        ),
                      ],
                    ),

                    // ── Seek bar ──
                    Expanded(
                      child: StreamBuilder(
                        stream: songNotifier.audioPlayer?.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration =
                              songNotifier.audioPlayer?.duration ??
                              Duration.zero;
                          double sliderValue = 0.0;
                          if (duration.inMilliseconds > 0) {
                            sliderValue =
                                (position.inMilliseconds /
                                        duration.inMilliseconds)
                                    .clamp(0.0, 1.0);
                          }

                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTickMarkColor: AColorTheme.gradient2,
                                  activeTrackColor: AColorTheme.gradient1,
                                  trackHeight: 4,
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  value: sliderValue,
                                  min: 0,
                                  max: 1,
                                  onChanged: (_) {},
                                  onChangeEnd: songNotifier.seek,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ${formatDuration(position)} ',
                                    style: TextTheme.of(context).bodySmall
                                        ?.copyWith(
                                          color: AColorTheme.greenColor
                                              .withAlpha(200),
                                        ),
                                  ),
                                  Text(
                                    ' ${formatDuration(duration)} ',
                                    style: TextTheme.of(context).bodySmall
                                        ?.copyWith(
                                          color: AColorTheme.whiteColor
                                              .withAlpha(170),
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // ── Controls ──
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(CupertinoIcons.shuffle, size: 30),

                          // Previous
                          GestureDetector(
                            onTap: () => songNotifier.previousSong(),
                            child: const Icon(Icons.skip_previous, size: 30),
                          ),

                          // Play/Pause — reads from stream
                          StreamBuilder(
                            stream: songNotifier.audioPlayer?.playerStateStream,
                            builder: (context, snapshot) {
                              final playing = snapshot.data?.playing ?? false;
                              final completed =
                                  snapshot.data?.processingState ==
                                  ProcessingState.completed;
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
                                          ? CupertinoIcons.pause_fill
                                          : CupertinoIcons.play_arrow_solid,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Next
                          GestureDetector(
                            onTap: () => songNotifier.nextSong(),
                            child: const Icon(Icons.skip_next, size: 30),
                          ),

                          const Icon(CupertinoIcons.loop, size: 30),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(CupertinoIcons.dot_radiowaves_left_right),
                          Icon(CupertinoIcons.list_number_rtl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
