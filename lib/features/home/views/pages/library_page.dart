import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/utilis/success.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs = ref
        .watch(homeViewmodelProvider.notifier)
        .getRecentlyPlayeSongs();
    ref.listen(homeViewmodelProvider, (_, data) {
      data.when(
        data: (data) {
          SuccessHelper.showSuccess(
            context,
            'Songs Fetched Successfully',
            'Success',
          );
        },
        error: (error, str) {
          SuccessHelper.showSuccess(
            context,
            'Error Fetching songs',
            'Song Fetch Error',
          );
        },
        loading: () {},
      );
    });
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latest Today', style: TextTheme.of(context).headlineLarge),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: recentlyPlayedSongs.length,
              itemBuilder: (context, index) {
                return SizedBox(height: 180);
              },
            ),
            SizedBox(height: 20),
            ref
                .watch(getAllSongsProvider)
                .when(
                  data: (data) {
                    return SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final song = data[index];
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(song.thumbnail),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      song.songName,
                                      style: TextTheme.of(context).bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                AColorTheme.inactiveSeekColor,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      'Artist: ${song.artistName}',
                                      style: TextTheme.of(context).bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AColorTheme.subtitleText,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, str) {
                    return Center(child: Text('Error: ${error.toString()}'));
                  },
                  loading: () {
                    return Text('Loading');
                  },
                ),
          ],
        ),
      ),
    );
  }
}
