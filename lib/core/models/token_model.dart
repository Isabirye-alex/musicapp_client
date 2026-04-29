class TokenModel {
  final String deviceToken;
  final String platform; 

 const TokenModel({
    required this.deviceToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      "device_token": deviceToken,
      "platform": platform,
    };
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      deviceToken: json["device_token"] ?? '',
      platform: json["platform"] ?? 'unknown',
    );
  } 
}