
class LocalSongModel {
  final String id;
  final String title;
  final String artist;
  final String path; // file path on device
  final int duration; // in ms

  LocalSongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.path,
    required this.duration,
  });
}
