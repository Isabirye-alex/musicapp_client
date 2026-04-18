// Helper to format Duration as mm:ss
String formatDuration(Duration? d) {
  if (d == null) return '0:00';
  final minutes = d.inMinutes.remainder(60);
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
