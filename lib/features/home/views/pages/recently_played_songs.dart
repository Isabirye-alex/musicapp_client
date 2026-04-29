import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';

class RecentlyPlayedSongs extends ConsumerWidget {
  const RecentlyPlayedSongs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs = ref
        .watch(homeViewmodelProvider.notifier)
        .getRecentlyPlayedSongs();

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: recentlyPlayedSongs.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final song = recentlyPlayedSongs[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.thumbnail,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              song.songName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artistName,
              style: TextStyle(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: GestureDetector(
              onTap: () => ref
                  .read(currentSongProvider.notifier)
                  .setPlaylist(recentlyPlayedSongs, startIndex: index),
              child: Icon(Icons.play_arrow, color: Colors.blueAccent),
            ),
          );
        },
      ),
    );
  }
}
