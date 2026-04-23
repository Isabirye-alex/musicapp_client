import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/repositories/home_local_repository.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';

class SongCard extends StatelessWidget {
  final RemoteSongModel song;
  final WidgetRef ref;

  const SongCard({super.key, required this.song, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(currentSongProvider.notifier).updateSong(song);
        ref.watch(homeLocalRepositoryProvider).uploadLocalSongs(song);
      
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(song.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 180,
              child: Text(
                song.songName,
                style: TextTheme.of(context).bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AColorTheme.inactiveSeekColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              width: 180,
              child: Text(
                song.artistName,
                style: TextTheme.of(
                  context,
                ).bodySmall!.copyWith(color: AColorTheme.subtitleText),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
