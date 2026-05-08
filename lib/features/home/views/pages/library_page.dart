import 'dart:async';

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
  Timer? _debounce;
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
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    _debounce?.cancel();
    setState(() => _isSearching = query.trim().isNotEmpty);
    ref.read(homeViewmodelProvider.notifier).searchSongs(query);
    _scrollController.jumpTo(0);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isSearching = query.trim().isNotEmpty);
      ref.read(homeViewmodelProvider.notifier).searchSongs(query);
      _scrollController.jumpTo(0);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
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
        ref.read(homeViewmodelProvider.notifier).refresh();
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(homeViewmodelProvider.notifier).refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            //Sticky search bar + sort chips
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 120, // ← fixed height now, no more conditional
              title: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── CustomAppBar ──────────────────────────────────────────
                    const CustomAppBar(),
                    const SizedBox(height: 8),
                    // ── Search + Sort on same row ─────────────────────────────
                    Row(
                      children: [
                        // Search field takes remaining space
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onTap: () => setState(() => _isSearching = true),
                            onSubmitted: _onSearchSubmitted,
                            onChanged: _onSearchChanged,
                            textInputAction: TextInputAction.search,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText:
                                  'Search...', // ← shorter hint, less cramped
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 18,
                              ),
                              suffixIcon: _isSearching
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.white.withAlpha(12),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        // Sort chips — collapse to icon-only when searching
                        if (!_isSearching) ...[
                          const SizedBox(width: 8),
                          SortChipClass(
                            label: 'New',
                            order: SongSortOrder.newest,
                          ),
                          const SizedBox(width: 4),
                          SortChipClass(
                            label: 'Old',
                            order: SongSortOrder.oldest,
                          ),
                          const SizedBox(width: 4),
                          SortChipClass(
                            label: 'A-Z',
                            order: SongSortOrder.name,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              titleSpacing: 16,
            ),
            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  _isSearching && _searchController.text.trim().isNotEmpty
                      ? 'Results for "${_searchController.text.trim()}"'
                      : 'Community Songs',
                  style: TextTheme.of(context).headlineMedium,
                ),
              ),
            ),

            //Content
            ref
                .watch(homeViewmodelProvider)
                .when(
                  skipLoadingOnReload: true,
                  data: (data) {
                    if (data.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Container(
                            height: 120,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AColorTheme.gradient1.withAlpha(20),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isSearching
                                        ? Icons.search_off
                                        : Icons.explore,
                                    size: 36,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _isSearching
                                        ? 'No results found'
                                        : 'No songs from other users yet',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final isConnected = ref.watch(networkProvider);
                    final hasMore = ref
                        .watch(homeViewmodelProvider.notifier)
                        .hasMore;

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // Offline banner
                        if (!isConnected)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                        // Grid
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
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
                        ),
                        // Pagination loader
                        if (hasMore && isConnected)
                          SizedBox(
                            height: 40,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ]),
                    );
                  },
                  error: (e, _) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.signal_wifi_connected_no_internet_4_rounded,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Connection Issue',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please check your internet and try again.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => ref
                                  .read(homeViewmodelProvider.notifier)
                                  .refresh(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AColorTheme.gradient1,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(Icons.refresh_rounded),
                              label: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  loading: () => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Loader()),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
