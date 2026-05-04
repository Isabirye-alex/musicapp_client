import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/current_song_notifier.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';
import 'package:little_music/features/home/viewmodel/recently_played_viewmodel.dart';
import 'package:little_music/utilis/color_converter.dart';
import 'package:little_music/utilis/name_helper.dart';

class SongCard extends StatefulWidget {
  final RemoteSongModel song;
  final WidgetRef ref;
  final List<RemoteSongModel> playlist;
  final int index;

  const SongCard({
    super.key,
    required this.song,
    required this.ref,
    required this.playlist,
    required this.index,
  });

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = hexToColor(widget.song.hexCode);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () async {
        final currentUser = widget.ref.read(currentUserProvider)?.user;

        final success = await widget.ref
            .read(currentSongProvider.notifier)
            .setPlaylist(widget.playlist, startIndex: widget.index);

        if (currentUser != null) {
          widget.ref
              .read(recentlyPlayedViewmodelProvider.notifier)
              .addToRecentlyPlayed(widget.song.songId);
        }

        if (!success && context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.red),
                  SizedBox(width: 8),
                  Text('No Internet'),
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
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Padding(
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thumbnail with gradient overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: widget.song.thumbnail,
                        height: size.height * 0.20,
                        width: size.width * 0.45,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 160,
                          width: 160,
                          color: color.withAlpha(60),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 160,
                          width: 160,
                          color: color.withAlpha(60),
                          child: Icon(
                            Icons.music_note_rounded,
                            color: color,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    // Bottom gradient for depth
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                color.withAlpha(180),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Hex color dot indicator
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withAlpha(180),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Song name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    capitalize(widget.song.songName),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 2),
                // Artist name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    widget.song.artistName,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                      letterSpacing: 0.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
