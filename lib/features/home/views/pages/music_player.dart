import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
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
            Color(0xff121212),
            Color(0xff009999),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AColorTheme.transparentColor,
        appBar: AppBar(backgroundColor: AColorTheme.transparentColor),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
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

              SizedBox(height: 5),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
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
                        Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.heart,
                            size: 40,
                            color: AColorTheme.card,
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: StreamBuilder(
                        stream: songNotifier.audioPlayer?.positionStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          final position = snapshot.data ?? Duration.zero;
                          final duration = songNotifier.audioPlayer?.duration;
                          double sliderValue =
                              position.inMilliseconds /
                              duration!.inMilliseconds;

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
                                  onChanged: (value) {
                                    sliderValue = value;
                                  },
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(CupertinoIcons.shuffle, size: 30),

                          GestureDetector(
                            onTap: () {
                              songNotifier.previousSong();
                            },
                            child: Icon(
                              CupertinoIcons.backward_end_alt,
                              size: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: songNotifier.playAndPause,
                            child: Container(
                              padding: EdgeInsets.all(2),

                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: AColorTheme.gradient1,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: songNotifier.isPlaying
                                    ? Icon(CupertinoIcons.pause_fill)
                                    : Icon(
                                        CupertinoIcons.play_arrow_solid,
                                        size: 30,
                                      ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: songNotifier.nextSong,
                            child: Icon(CupertinoIcons.forward_end_alt, size: 30),
                          ),
                          Icon(CupertinoIcons.loop, size: 30),
                        ],
                      ),
                    ),
                    // Expanded(child: SizedBox()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
