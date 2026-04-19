// lib/features/local_songs/views/local_songs_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/local_song_notifier.dart';
import 'package:on_audio_query/on_audio_query.dart';


class LocalSongsPage extends ConsumerWidget {
  const LocalSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(localSongsProvider);
    final notifier = ref.read(localSongsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Device Music')),
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (songs) => songs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No music found on device'),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isCurrent = notifier.currentSong?.id == song.id;

                  return ListTile(
                    // artwork query
                    leading: QueryArtworkWidget(
                      id: int.parse(song.id),
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const CircleAvatar(
                        child: Icon(Icons.music_note),
                      ),
                    ),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(song.artist),
                    trailing: isCurrent
                        ? IconButton(
                            icon: Icon(
                              notifier.isPlaying
                                  ? CupertinoIcons.pause
                                  : CupertinoIcons.play_arrow_solid,
                            ),
                            onPressed: notifier.playAndPause,
                          )
                        : null,
                    onTap: () => notifier.playSong(song),
                  );
                },
              ),
      ),
    );
  }
}
