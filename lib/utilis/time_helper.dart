// Time formatting utilities
// Provides functions to format Duration objects into readable strings

/// Formats a Duration object into a human-readable string
/// Examples: "3:45" for 3 minutes 45 seconds, "1:23:45" for 1 hour 23 minutes 45 seconds
/// Returns '0:00' if the duration is null
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
