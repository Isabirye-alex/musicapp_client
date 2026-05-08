import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/notifiers/download_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/home/models/sealed_model_class.dart';

class DownloadButton extends ConsumerStatefulWidget {
  final RemoteSongModel song;
  final double size;

  const DownloadButton({
    super.key,
    required this.song,
    this.size = 20,
  });

  @override
  ConsumerState<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends ConsumerState<DownloadButton> {
  @override
  void initState() {
    super.initState();
    // sync actual file state on first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadProvider.notifier).syncState(widget.song.songId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloadMap = ref.watch(downloadProvider);
    final downloadState = downloadMap[widget.song.songId] ?? DownloadState.idle;

    return GestureDetector(
      onTap: () => ref.read(downloadProvider.notifier).toggle(widget.song),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(120),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: switch (downloadState) {
            DownloadState.downloading => SizedBox(
                width: widget.size - 4,
                height: widget.size - 4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AColorTheme.gradient1,
                ),
              ),
            DownloadState.downloaded => Icon(
                Icons.download_done_rounded,
                size: widget.size,
                color: AColorTheme.gradient1,
              ),
            DownloadState.idle => Icon(
                Icons.download_outlined,
                size: widget.size,
                color: Colors.white,
              ),
          },
        ),
      ),
    );
  }
}