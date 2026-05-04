import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/network_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';
import 'package:little_music/features/home/views/widgets/reusable_song_card.dart';
import 'package:little_music/features/home/views/widgets/sort_chip_class.dart';
import 'package:little_music/utilis/loader.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends ConsumerState<LibraryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(homeViewmodelProvider);
      final songs = currentState.value ?? [];
      if (songs.isEmpty) {
        ref.read(homeViewmodelProvider.notifier).fetchNextPage();
      }
    });

    _scrollController.addListener(() {
      final atBottom =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200;
      if (atBottom) {
        final isConnected = ref.read(networkProvider);
        if (!isConnected) {
          return;
        }
        final isLoading = ref.read(homeViewmodelProvider).isLoading;
        if (!isLoading) {
          ref.read(homeViewmodelProvider.notifier).fetchNextPage();
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
    ref.listen(networkProvider, (previous, isConnected) {
      final wasDisconnected = previous == false;
      if (isConnected && wasDisconnected) {
        ref.watch(homeViewmodelProvider.notifier).refresh();
      }
    });
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(homeViewmodelProvider.notifier).refresh();
          },
          child: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SortChipClass(label: 'Newest', order: SongSortOrder.newest),
                  SizedBox(width: 8),
                  SortChipClass(label: 'Oldest', order: SongSortOrder.oldest),
                  SizedBox(width: 8),
                  SortChipClass(label: 'Name', order: SongSortOrder.name),
                ],
              ),
              Text(
                'Community Songs',
                style: TextTheme.of(context).headlineMedium,
              ),
              SizedBox(height: 12),
              ref
                  .watch(homeViewmodelProvider)
                  .when(
                    skipLoadingOnReload: true,
                    data: (data) {
                      if (data.isEmpty) {
                        return Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AColorTheme.gradient1.withAlpha(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.explore,
                                  size: 36,
                                  color: Colors.grey,
                                ),
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

                      final isConnected = ref.watch(
                        networkProvider,
                      ); // ← watch network
                      final hasMore = ref
                          .watch(homeViewmodelProvider.notifier)
                          .hasMore;

                      return Column(
                        children: [
                          // offline banner
                          if (!isConnected)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.offline_bolt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Showing cached content',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 10),
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisSpacing: 2,
                                  mainAxisExtent: 240,
                                  crossAxisSpacing: 12,
                                ),
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final song = data[index];
                              return SongCard(
                                key: ValueKey(song.songId),
                                song: song,
                                ref: ref,
                                playlist: data,
                                index: index,
                              );
                            },
                          ),
                          // ← only show loader if online AND has more pages AND currently loading
                          if (hasMore && isConnected)
                            SizedBox(
                              height: 40,
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please check your internet and try again.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => ref
                                  .read(homeViewmodelProvider.notifier)
                                  .refresh(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AColorTheme.gradient1,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
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
                    loading: () => Loader(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
