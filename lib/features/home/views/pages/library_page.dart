import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/reusable_song_card.dart';
import 'package:little_music/utilis/loader.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs = ref
        .watch(homeViewmodelProvider.notifier).getRecentlyPlayedSongs();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 20,
        ),
        child: ListView(
          children: [
            //Recently Played
            if (recentlyPlayedSongs.isNotEmpty) ...[
              Text(
                'Recently Played',
                style: TextTheme.of(context).headlineMedium,
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 150,
                  childAspectRatio: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final song = recentlyPlayedSongs[index];
                  return GestureDetector(
                    onTap: () =>
                        ref.read(currentSongProvider.notifier).updateSong(song),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(song.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withAlpha(120),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          song.songName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],

            //Your Uploads
            Text('Your Uploads', style: TextTheme.of(context).headlineMedium),
            const SizedBox(height: 12),
            ref
                .watch(getAllSongsProvider)
                .when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AColorTheme.gradient1.withAlpha(20),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload, size: 36, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'You haven\'t uploaded any songs yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final song = data[index];
                          return SongCard(song: song, ref: ref);
                        },
                      ),
                    );
                  },
                  error: (e, _) => Text(
                    'Error loading your songs',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  loading: () => const Loader(),
                ),

            const SizedBox(height: 24),

            //Discover — All Platform Songs
            Text('Discover', style: TextTheme.of(context).headlineMedium),
            const SizedBox(height: 12),
            ref
                .watch(getAllPlatformSongsProvider)
                .when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AColorTheme.gradient1.withAlpha(20),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.explore, size: 36, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'No songs from other users yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 10),
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 2,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final song = data[index];
                        return SongCard(song: song, ref: ref);
                      },
                    );
                  },
                  error: (e, _) => Text(
                    'Error loading discover songs',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
