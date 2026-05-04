import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/viewmodel/recently_played_viewmodel.dart';
import 'package:little_music/utilis/name_helper.dart';

class SongCard extends StatelessWidget {
  final RemoteSongModel song;
  final WidgetRef ref;
  final List<RemoteSongModel> playlist;
  final int index;
  const SongCard({
    super.key,
    required this.song,
    required this.ref,
    required this.playlist,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final currentUser = ref.watch(currentUserProvider)?.user;

        final success = await ref
            .read(currentSongProvider.notifier)
            .setPlaylist(playlist, startIndex: index);
     
        if (currentUser != null) {
      
          ref
              .watch(recentlyPlayedViewmodelProvider.notifier)
              .addToRecentlyPlayed(song.songId);
        }

        if (!success && context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.red),
                  SizedBox(width: 8),
                  Text('No Internet'),
                ],
              ),
              content: Text(
                'You need an internet connection to play songs. Please connect and try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(song.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 180,
              child: Text(
                ' ${capitalize(song.songName)}',
                style: TextTheme.of(
                  context,
                ).bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              width: 180,
              child: Text(
                song.artistName,
                style: TextTheme.of(context).bodySmall!.copyWith(),
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
