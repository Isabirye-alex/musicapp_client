import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';
import 'package:little_music/features/home/views/widgets/empty_listen_page.dart';

class RecentlyPlayedSongs extends ConsumerWidget {
  const RecentlyPlayedSongs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs = ref
        .watch(homeViewmodelProvider.notifier)
        .getRecentlyPlayedSongs();

    return Scaffold(
      appBar: CustomAppBar(),
      body: recentlyPlayedSongs.isEmpty
          ? EmptyStateListen()
          : ListView.separated(
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
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(song.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                    onTap: () async {
                      final success = await ref
                          .read(currentSongProvider.notifier)
                          .setPlaylist(recentlyPlayedSongs, startIndex: index);

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
                    child: Icon(Icons.play_arrow, color: Colors.blueAccent),

                  ),
                );
              },
            ),
    );
  }
}
