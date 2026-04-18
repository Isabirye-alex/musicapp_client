// ignore_for_file: public_member_api_docs, sort_constructors_first
class SongModel {
  final String song;
  final String thumbnail;
  final String artistName;
  final String songName;
  final String hexCode;
  final String songId;
  final String userId;

  const SongModel({
    required this.song,
    required this.thumbnail,
    required this.artistName,
    required this.songName,
    required this.hexCode,
    required this.songId,
    required this.userId,
  });


  Map<String, dynamic> toJson() {
    return {
      'song_url': song,
      'thumbnail_url': thumbnail,
      'artist_name': artistName,
      'song_name': songName,
      'hex_node': hexCode,
      'song_id': songId,
      'user_id': userId,
    };
  }

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      song: json['song_url'] ?? '',
      thumbnail: json['thumbnail_url'] ?? '',
      artistName: json['artist_name'] ?? '',
      songName: json['song_name'] ?? '',
      hexCode: json['hex_code'] ?? '',
      songId: json['song_id'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  SongModel copyWith({
    String? song,
    String? thumbnail,
    String? artistName,
    String? songName,
    String? hexCode,
    String? songId,
    String? userId,
  }) {
    return SongModel(
      song: song ?? this.song,
      thumbnail: thumbnail ?? this.thumbnail,
      artistName: artistName ?? this.artistName,
      songName: songName ?? this.songName,
      hexCode: hexCode ?? this.hexCode,
      songId: songId ?? this.songId,
      userId: userId ?? this.userId,
    );
  }


}
