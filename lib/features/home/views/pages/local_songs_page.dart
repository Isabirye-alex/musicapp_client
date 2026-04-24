import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../viewmodel/home_viewmodel.dart';

class LocalSongsPage extends ConsumerWidget {
  const LocalSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(getDeviceSongsProvider);
    final currentSong = ref.watch(currentSongProvider);
    final notifier = ref.read(currentSongProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text('Device Music', style: TextTheme.of(context).headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: (){},
          ),
        ],
      ),
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed:(){},
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (songs) => songs.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.music_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No songs found on your device',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
            : Column(
          children: [

            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isCurrent = currentSong?.id == song.id;

                  return ListTile(
                    selected: isCurrent,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha(100),
                    leading: CircleAvatar(
                      backgroundColor: isCurrent
                          ? AColorTheme.gradient3
                          : AColorTheme.gradient2,
                      child: isCurrent
                          ? const Icon(
                        CupertinoIcons.music_note,
                        color: Colors.white,
                        size: 18,
                      )
                          : Text(
                        song.title[0].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isCurrent
                          ? TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )
                          : null,
                    ),
                    subtitle: Text(
                      '${song.artist} • ${song.formattedDuration}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isCurrent
                        ? IconButton(
                      icon: Icon(
                        notifier.isPlaying
                            ? CupertinoIcons.pause_circle_fill
                            : CupertinoIcons.play_circle_fill,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: notifier.playAndPause,
                    )
                        : null,
                    onTap: () => notifier.updateSong(song),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}