import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/viewmodel/home_viewmodel.dart';
import 'package:little_music/features/home/views/pages/upload_song_page.dart';
import 'package:little_music/features/home/views/widgets/custom_app_bar.dart';
import 'package:little_music/features/home/views/widgets/reusable_song_card.dart';
import 'package:little_music/utilis/loader.dart';

class YourUploads extends ConsumerWidget {
  const YourUploads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UploadSongPage()),
        ),
        backgroundColor: AColorTheme.gradient1,
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Upload Song',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        color: AColorTheme.gradient1,
        onRefresh: () async {
          ref.invalidate(getAllSongsProvider);
          await ref.read(getAllSongsProvider.future);
        },
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Your Uploads', style: TextTheme.of(context).headlineMedium),
            SizedBox(height: 12),
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
                        child: Center(
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
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // important
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75, // adjust for card shape
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final song = data[index];
                        return SongCard(
                          song: song,
                          ref: ref,
                          playlist: data,
                          index: index,
                          key: ValueKey(song.songId),
                        );
                      },
                    );
                  },
                  error: (e, _) => Text(
                    'Error loading your songs',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  loading: () => Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
