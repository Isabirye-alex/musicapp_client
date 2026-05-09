import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/core/widgets/play_pause_button.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/utilis/color_converter.dart';
import 'package:little_music/utilis/time_helper.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../utilis/queue_sheet.dart';
import '../../../../utilis/volume_sheet.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.watch(currentSongProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToColor(currentSong!.hexCode).withAlpha(200),
            const Color(0xff121212),
          ],
          stops: const [0.0, 0.5],
        ),
      ),
      child: Scaffold(
        backgroundColor: AColorTheme.transparentColor,
        appBar: AppBar(
          backgroundColor: AColorTheme.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Now Playing',
            style: TextTheme.of(context).labelSmall?.copyWith(
              color: AColorTheme.whiteColor.withAlpha(170),
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, size: 24),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Artwork
              Hero(
                tag: 'music-image',
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Song info + favourite
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSong.displayTitle,
                          style: TextTheme.of(context).titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentSong.displayArtist,
                          style: TextTheme.of(context).bodyMedium?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: AColorTheme.whiteColor.withAlpha(160),
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(
                      currentSong is RemoteSongModel &&
                          currentSong.isFavorite == true
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 26,
                    ),
                    color: currentSong is RemoteSongModel &&
                        currentSong.isFavorite == true
                        ? Colors.pinkAccent
                        : AColorTheme.whiteColor.withAlpha(180),
                    onPressed: () {
                      if (currentSong is RemoteSongModel) {
                        songNotifier.updateFavoriteStatus(
                          (currentSong.isFavorite ),
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Seek bar
              StreamBuilder(
                stream: songNotifier.audioPlayer?.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration =
                      songNotifier.audioPlayer?.duration ?? Duration.zero;
                  double sliderValue = 0.0;
                  if (duration.inMilliseconds > 0) {
                    sliderValue = (position.inMilliseconds /
                        duration.inMilliseconds)
                        .clamp(0.0, 1.0);
                  }

                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AColorTheme.whiteColor,
                          inactiveTrackColor:
                          AColorTheme.whiteColor.withAlpha(60),
                          thumbColor: AColorTheme.whiteColor,
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 5,
                          ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDuration(position),
                              style: TextTheme.of(context).labelSmall?.copyWith(
                                color: AColorTheme.whiteColor.withAlpha(180),
                              ),
                            ),
                            Text(
                              formatDuration(duration),
                              style: TextTheme.of(context).labelSmall?.copyWith(
                                color: AColorTheme.whiteColor.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Main controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 36),
                    color: AColorTheme.whiteColor,
                    onPressed: () => songNotifier.previousSong(),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: PlayPauseButton(songNotifier: songNotifier),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 36),
                    color: AColorTheme.whiteColor,
                    onPressed: () => songNotifier.nextSong(),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Extra controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Repeat — reacts live to loop mode changes
                  StreamBuilder<LoopMode>(
                    stream: songNotifier.audioPlayer?.loopModeStream,
                    builder: (context, snapshot) {
                      final isRepeat = snapshot.data == LoopMode.one;
                      return IconButton(
                        tooltip: 'Repeat',
                        icon: Icon(
                          Icons.repeat_rounded,
                          size: 22,
                          color: isRepeat
                              ? AColorTheme.gradient1
                              : AColorTheme.whiteColor.withAlpha(150),
                        ),
                        onPressed: () => songNotifier.toggleRepeat(),
                      );
                    },
                  ),

                  // Volume — opens bottom sheet
                  IconButton(
                    tooltip: 'Volume',
                    icon: Icon(
                      Icons.volume_up_rounded,
                      size: 22,
                      color: AColorTheme.whiteColor.withAlpha(150),
                    ),
                    onPressed: () => showVolumeSheet(context, songNotifier),
                  ),

                  // Shuffle — reacts live to shuffle mode changes
                  StreamBuilder<bool>(
                    stream: songNotifier.audioPlayer?.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final isShuffle = snapshot.data ?? false;
                      return IconButton(
                        tooltip: 'Shuffle',
                        icon: Icon(
                          Icons.shuffle_rounded,
                          size: 22,
                          color: isShuffle
                              ? AColorTheme.accent
                              : AColorTheme.whiteColor.withAlpha(150),
                        ),
                        onPressed: () => songNotifier.toggleShuffle(),
                      );
                    },
                  ),

                  // Queue — opens draggable song list
                  IconButton(
                    tooltip: 'Queue',
                    icon: Icon(
                      Icons.queue_music_rounded,
                      size: 22,
                      color: AColorTheme.whiteColor.withAlpha(150),
                    ),
                    onPressed: () =>
                        showQueueSheet(context, songNotifier, currentSong),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }
}