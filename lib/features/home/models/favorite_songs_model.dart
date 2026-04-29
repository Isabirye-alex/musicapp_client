class FavoriteSongsModel {
  final String songId;
  final String token;

  const FavoriteSongsModel({
    required this.songId,
    required this.token,
  });

  factory FavoriteSongsModel.fromJson(Map<String, dynamic> json) {
    return FavoriteSongsModel(
      songId: json['songId'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'token': token,
    };
  }
}