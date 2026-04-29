class TokenModel {
  final String token;
  final String platform;

  const TokenModel({required this.token, required this.platform});

  Map<String, dynamic> toJson() {
    return {"token": token, "platform": platform};
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json["token"] ?? '',
      platform: json["platform"] ?? 'unknown',
    );
  }
}
