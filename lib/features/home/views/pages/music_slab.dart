import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/views/pages/music_player.dart';
import 'package:little_music/utilis/color_converter.dart';
import 'package:little_music/utilis/time_helper.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.watch(currentSongProvider.notifier);
    if (currentSong == null) {
      return SizedBox();
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
                    begin: Offset(0, 1),
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
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hexCode),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(currentSong.thumbnail),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.songName,
                          style: TextTheme.of(
                            context,
                          ).bodyMedium!.copyWith(color: AColorTheme.gradient1),
                        ),
                        Text(
                          currentSong.artistName,
                          style: TextTheme.of(context).bodyMedium!.copyWith(
                            color: AColorTheme.subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream: songNotifier.audioPlayer?.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }

                        final position = snapshot.data ?? Duration.zero;
                        final duration = songNotifier.audioPlayer?.duration;

                        return Text(
                          '${formatDuration(position)} / ${formatDuration(duration)}',
                          style: TextTheme.of(context).bodySmall?.copyWith(
                            color: AColorTheme.primary.withAlpha(100),
                          ),
                        );
                      },
                    ),

                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(CupertinoIcons.heart),
                        ),
                        IconButton(
                          onPressed: () {
                            songNotifier.playAndPause();
                          },
                          icon: songNotifier.isPlaying
                              ? Icon(CupertinoIcons.pause)
                              : Icon(CupertinoIcons.play_arrow_solid),
                        ),
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              final position = snapshot.data;
              final duration = songNotifier.audioPlayer?.duration;
              double sliderValue = 0.0;

              if (position != null &&
                  duration != null &&
                  duration.inMilliseconds > 0) {
                sliderValue =
                    position.inMilliseconds / duration.inMilliseconds; //
                sliderValue = sliderValue.clamp(0.0, 1.0);
              }

              return Positioned(
                bottom: 0,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      flex: (sliderValue * 100).toInt(),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(color: AColorTheme.gradient1),
                      ),
                    ),
                    Expanded(
                      flex: ((1 - sliderValue) * 100).toInt(),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AColorTheme.gradient1.withAlpha(100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
