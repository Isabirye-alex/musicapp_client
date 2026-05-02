import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/pages/upload_song_page.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';
import 'package:little_music/features/home/views/widgets/empy_upload_page.dart';
import 'package:little_music/features/home/views/widgets/reusable_song_card.dart';
import 'package:little_music/utilis/loader.dart';

class YourUploads extends ConsumerWidget {
  const YourUploads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UploadSongPage()),
        ),
        backgroundColor: AColorTheme.gradient1,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Upload',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        color: AColorTheme.gradient1,
        onRefresh: () async {
          ref.invalidate(getAllSongsProvider);
          await ref.read(getAllSongsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

            
            ref
                .watch(getAllSongsProvider)
                .when(
                  data: (data) {
                    if (data.isEmpty) {
                      return EmptyState();
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
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
                    );
                  },
                  
                  error: (e, _) => Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.red.shade300),
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
