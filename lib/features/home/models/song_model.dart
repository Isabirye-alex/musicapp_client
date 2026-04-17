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

  

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      song: json['song'],
      thumbnail: json['thumbnail'],
      artistName: json['artistName'],
      songName: json['songName'],
      hexCode: json['hexCode'],
      songId: json['songId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'song': song,
      'thumbnail': thumbnail,
      'artistName': artistName,
      'songName': songName,
      'hexCode': hexCode,
      'songId': songId,
      'userId': userId,
    };
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
