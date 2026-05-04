import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/features/home/viewmodel/recently_played_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';
import 'package:little_music/features/home/views/widgets/empty_listen_page.dart';

class RecentlyPlayedSongs extends ConsumerStatefulWidget {
  const RecentlyPlayedSongs({super.key});

  @override
  ConsumerState<RecentlyPlayedSongs> createState() =>
      _RecentlyPlayedSongsState();
}

class _RecentlyPlayedSongsState extends ConsumerState<RecentlyPlayedSongs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial songs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentlyPlayedViewmodelProvider.notifier).fetchNextPage();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final viewModel = ref.read(recentlyPlayedViewmodelProvider.notifier);

    // Load more when near the bottom (200 pixels before end)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (viewModel.hasMore && !viewModel.isLoadingMore) {
        viewModel.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recentlyPlayedViewmodelProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (songs) {
          if (songs.isEmpty) {
            return const EmptyStateListen();
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: songs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom
              if (index == songs.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final song = songs[index];
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
                        .setPlaylist(songs, startIndex: index);

                    if (!success && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: [
                              const Icon(Icons.wifi_off, color: Colors.red),
                              const SizedBox(width: 8),
                              const Text('No Internet'),
                            ],
                          ),
                          content: const Text(
                            'You need an internet connection to play songs. Please connect and try again.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.play_arrow, color: Colors.blueAccent),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
