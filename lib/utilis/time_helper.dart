String formatDuration(Duration? d) {
  if (d == null) return '0:00';
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');

  if (hours != 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}