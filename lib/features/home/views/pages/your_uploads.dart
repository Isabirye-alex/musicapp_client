import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/network_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/user_songs_notifier.dart';
import 'package:little_music/features/home/views/pages/upload_song_page.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';
import 'package:little_music/features/home/views/widgets/empty_upload_page.dart';
import 'package:little_music/features/home/views/widgets/reusable_song_card.dart';
import 'package:little_music/utilis/loader.dart';

class YourUploads extends ConsumerStatefulWidget {
  const YourUploads({super.key});

  @override
  ConsumerState<YourUploads> createState() => _YourUploadsState();
}

class _YourUploadsState extends ConsumerState<YourUploads> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(userSongsProvider);
      final songs = currentState.value ?? [];
      if (songs.isEmpty) {
        ref.read(userSongsProvider.notifier).fetchNextPage();
      }
    });

    // pagination on scroll
    _scrollController.addListener(() {
      final atBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200;
      if (atBottom) {
        final isLoading = ref.read(userSongsProvider).isLoading;
        final isConnected = ref.read(networkProvider);
        if (!isLoading && isConnected) {
          ref.read(userSongsProvider.notifier).fetchNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // auto refresh when internet comes back
    ref.listen(networkProvider, (previous, isConnected) {
      if (isConnected && previous == false) {
        ref.read(userSongsProvider.notifier).refresh();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // ← positions it above nav bar
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80), // ← pushes it above nav bar + music slab
        child: FloatingActionButton(
          elevation: 4,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UploadSongPage()),
          ),
          backgroundColor: AColorTheme.gradient1,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: AColorTheme.gradient1,
        onRefresh: () async {
          await ref.read(userSongsProvider.notifier).refresh();
        },
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 160, // ← stops content from hiding behind nav bar + slab + fab
          ),
    children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Uploads',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.library_music_rounded, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Manage and play your uploaded songs',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // offline banner
            if (!ref.watch(networkProvider))
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.offline_bolt, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Showing cached content',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),

            ref.watch(userSongsProvider).when(
              skipLoadingOnReload: true,
              data: (data) {
                if (data.isEmpty) return EmptyState();

                final hasMore = ref.read(userSongsProvider.notifier).hasMore;
                final isConnected = ref.watch(networkProvider);

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final song = data[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(16),
                            child: SongCard(
                              key: ValueKey(song.songId),
                              song: song,
                              ref: ref,
                              playlist: data,
                              index: index,
                            ),
                          ),
                        );
                      },
                    ),

                    // bottom loader — only when online and has more
                    if (hasMore && isConnected)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.signal_wifi_connected_no_internet_4_rounded,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connection Issue',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your internet and try again.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            ref.read(userSongsProvider.notifier).refresh(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AColorTheme.gradient1,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Loader(),
            ),
          ],
        ),
      ),
    );
  }
}