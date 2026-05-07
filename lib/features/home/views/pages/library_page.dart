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
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;                                               

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
        if (!isConnected) return;
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

  void _onSearchSubmitted(String query) {
    ref.read(homeViewmodelProvider.notifier).searchSongs(query);
    _scrollController.jumpTo(0);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
    ref.read(homeViewmodelProvider.notifier).clearSearch();
    _scrollController.jumpTo(0);
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
              // ── Search bar
              TextField(
                controller: _searchController,
                onTap: () => setState(() => _isSearching = true),
                onSubmitted: _onSearchSubmitted,
                textInputAction: TextInputAction.search,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search songs or artists...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _isSearching
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withAlpha(12),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sort chips (hidden while searching)
              if (!_isSearching) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SortChipClass(label: 'Newest', order: SongSortOrder.newest),
                    const SizedBox(width: 8),
                    SortChipClass(label: 'Oldest', order: SongSortOrder.oldest),
                    const SizedBox(width: 8),
                    SortChipClass(label: 'Name', order: SongSortOrder.name),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              Text(
                _isSearching && _searchController.text.trim().isNotEmpty
                    ? 'Results for "${_searchController.text.trim()}"'
                    : 'Community Songs',
                style: TextTheme.of(context).headlineMedium,
              ),
              const SizedBox(height: 12),

              ref.watch(homeViewmodelProvider).when(
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
                              _isSearching ? Icons.search_off : Icons.explore,
                              size: 36,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isSearching
                                  ? 'No results found'
                                  : 'No songs from other users yet',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final isConnected = ref.watch(networkProvider);
                  final hasMore =
                      ref.watch(homeViewmodelProvider.notifier).hasMore;

                  return Column(
                    children: [
                      if (!isConnected)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade800,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.offline_bolt,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Showing cached content',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
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
                      if (hasMore && isConnected)
                        const SizedBox(
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your internet and try again.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              ref.read(homeViewmodelProvider.notifier).refresh(),
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
      ),
    );
  }
}