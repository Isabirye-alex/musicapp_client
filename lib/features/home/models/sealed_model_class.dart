// ignore_for_file: unused_local_variable

//Sealed union

sealed class SongsModel {
  const SongsModel();

  bool get favoriteStatus => switch (this) {
    RemoteSongModel s => s.isFavorite,
    LocalSongModel _ => false,
  };

  String get displayTitle => switch (this) {
    RemoteSongModel s => s.songName,
    LocalSongModel s => s.title,
  };

  String get displayArtist => switch (this) {
    RemoteSongModel s => s.artistName,
    LocalSongModel s => s.artist,
  };

  String get audioPath => switch (this) {
    RemoteSongModel s => s.song,
    LocalSongModel s => s.path,
  };

  String get id => switch (this) {
    RemoteSongModel s => s.songId,
    LocalSongModel s => s.id,
  };

  String get thumbnailUrl => switch (this) {
    RemoteSongModel s => s.thumbnail,
    LocalSongModel s => '',
  };

  String get hexCode => switch (this) {
    RemoteSongModel s => s.hexCode,
    LocalSongModel s => 'ff121212', // default dark colour for local songs
  };
}

//Remote (platform/server) song

class RemoteSongModel extends SongsModel {
  final String song;
  final bool isFavorite;
  final String thumbnail;
  final String artistName;
  final String songName;
  DateTime? createdAt;
  DateTime? updatedAt;
  @override
  final String hexCode;
  final String songId;
  final String userId;

  RemoteSongModel({
    required this.song,
    this.isFavorite = false,
    required this.thumbnail,
    required this.artistName,
    required this.songName,
    required this.hexCode,
    required this.songId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'song_url': song,
    'thumbnail_url': thumbnail,
    'artist_name': artistName,
    'song_name': songName,
    'hex_node': hexCode,
    'song_id': songId,
    'user_id': userId,
    'is_favorite': isFavorite,
  };

  factory RemoteSongModel.fromJson(Map<String, dynamic> json) {
    return RemoteSongModel(
      song: json['song_url'] ?? '',
      thumbnail: json['thumbnail_url'] ?? '',
      artistName: json['artist_name'] ?? '',
      songName: json['song_name'] ?? '',
      hexCode: json['hex_code'] ?? '',
      songId: json['song_id'] ?? '',
      userId: json['user_id'] ?? '',
      createdAt: json["created_at"] == null
          ? null
          : json['created_at'] is DateTime
          ? json['created_at'] as DateTime
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : json['updated_at'] is DateTime
          ? json['updated_at'] as DateTime
          : DateTime.parse(json["updated_at"]),
    );
  }

  RemoteSongModel copyWith({
    String? song,
    String? thumbnail,
    String? artistName,
    String? songName,
    String? hexCode,
    String? songId,
    String? userId,
    bool? isFavorite,
  }) {
    return RemoteSongModel(
      song: song ?? this.song,
      thumbnail: thumbnail ?? this.thumbnail,
      artistName: artistName ?? this.artistName,
      songName: songName ?? this.songName,
      hexCode: hexCode ?? this.hexCode,
      songId: songId ?? this.songId,
      userId: userId ?? this.userId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

//Local (device) song

class LocalSongModel extends SongsModel {
  @override
  final String id;
  final String title;
  final String artist;
  final String album;
  final String path;
  final int duration;
  final int? albumId;
  final int? dateAdded;
  final int? fileSize;

  const LocalSongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    required this.duration,
    this.albumId,
    this.dateAdded,
    this.fileSize,
  });


  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'album': album,
    'path': path,
    'duration': duration,
    'albumId': albumId,
    'dateAdded': dateAdded,
    'fileSize': fileSize,
  };

  factory LocalSongModel.fromJson(Map<String, dynamic> json) {
    return LocalSongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      path: json['path'] as String,
      duration: json['duration'] as int,
      albumId: json['albumId'] as int?,
      dateAdded: json['dateAdded'] as int?,
      fileSize: json['fileSize'] as int?,
    );
  }

  String get formattedDuration {
    final total = Duration(milliseconds: duration);
    final minutes = total.inMinutes;
    final seconds = total.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedFileSize {
    if (fileSize == null) return 'Unknown';
    final mb = fileSize! / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  LocalSongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? path,
    int? duration,
    int? albumId,
    int? dateAdded,
    int? fileSize,
  }) {
    return LocalSongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      path: path ?? this.path,
      duration: duration ?? this.duration,
      albumId: albumId ?? this.albumId,
      dateAdded: dateAdded ?? this.dateAdded,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}
