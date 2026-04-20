// lib/features/local_songs/views/local_songs_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/local_song_notifier.dart';

class LocalSongsPage extends ConsumerWidget {
  const LocalSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(localSongsProvider);
    final notifier = ref.read(localSongsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Device Music')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: notifier.pickAndAddSongs,
        icon: const Icon(Icons.add),
        label: const Text('Add Songs'),
      ),
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (songs) => songs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Tap + to add songs from your device'),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isCurrent = notifier.currentSong?.id == song.id;

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(song.title[0].toUpperCase()),
                    ),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(song.artist),
                    trailing: isCurrent
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.backward_end_fill,
                                ),
                                onPressed: notifier.hasPrevious
                                    ? notifier.previousSong
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  notifier.isPlaying
                                      ? CupertinoIcons.pause
                                      : CupertinoIcons.play_arrow_solid,
                                ),
                                onPressed: notifier.playAndPause,
                              ),
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.forward_end_fill,
                                ),
                                onPressed: notifier.hasNext
                                    ? notifier.nextSong
                                    : null,
                              ),
                            ],
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
