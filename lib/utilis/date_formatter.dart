import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// "Apr 27, 2026 - 19:04"
  String toReadableFull() {
    return DateFormat('MMM d, yyyy - HH:mm').format(toLocal());
  }

  /// "Apr 27, 2026"
  String toReadableDate() {
    return DateFormat('MMM d, yyyy').format(toLocal());
  }

  /// "19:04"
  String toReadableTime() {
    return DateFormat('HH:mm').format(toLocal());
  }

  String toRelative() {
    final now = DateTime.now();
    final local = toLocal();
    final diff = now.difference(local);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEEE').format(local);
    return toReadableDate();
  }
}

extension DurationFormatting on Duration {
  /// "3:45" or "1:02:30" for tracks over an hour
  String toTrackDuration() {
    final h = inHours;
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}