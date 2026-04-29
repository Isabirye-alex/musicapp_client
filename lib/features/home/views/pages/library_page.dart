import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(homeViewmodelProvider.notifier).refresh();
          },
          child: ListView(
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
                'Commnity Songs',
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
                      final hasMore = ref
                          .read(homeViewmodelProvider.notifier)
                          .hasMore;
                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 10),
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisSpacing: 0,
                                  mainAxisExtent: 250,
                                  crossAxisSpacing: 2,
                                ),
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              if (index == data.length) {
                                return hasMore
                                    ? SizedBox(
                                        height: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              }
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
                          if (hasMore)
                            SizedBox(
                              height: 40,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      );
                    },
                    error: (e, _) => Text(
                      'Error loading discover songs $e',
                      style: TextStyle(color: Colors.red[300]),
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
