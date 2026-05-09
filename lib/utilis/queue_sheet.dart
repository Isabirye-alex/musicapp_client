import 'package:flutter/material.dart';

import '../core/providers/current_song_notifier.dart';
import '../core/theme/a_color_theme.dart';
import '../features/home/models/sealed_model_class.dart';

void showQueueSheet(
    BuildContext context,
    CurrentSongNotifier notifier,
    SongsModel? currentSong,
    ) {
  showModalBottomSheet(
    isDismissible: true,
    context: context,
    backgroundColor: const Color(0xff1e1e1e),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  'Up Next',
                  style: TextTheme.of(context).titleMedium?.copyWith(
                    color: AColorTheme.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${notifier.songs.length} songs',
                  style: TextTheme.of(context).bodySmall?.copyWith(
                    color: AColorTheme.whiteColor.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: notifier.songs.length,
              itemBuilder: (_, i) {
                final song = notifier.songs[i];
                final isCurrent = currentSong is RemoteSongModel &&
                    song.id == currentSong.id;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.thumbnailUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent
                          ? AColorTheme.gradient1
                          : AColorTheme.whiteColor,
                      fontWeight:
                      isCurrent ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    song.displayArtist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AColorTheme.whiteColor.withAlpha(120),
                      fontSize: 12,
                    ),
                  ),
                  trailing: isCurrent
                      ? Icon(Icons.equalizer_rounded,
                      color: AColorTheme.gradient1, size: 20)
                      : null,
                  onTap: () {
                    notifier.playSpecific(song);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
