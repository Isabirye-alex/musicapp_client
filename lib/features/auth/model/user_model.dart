class UserModel {
  User user;
  String accessToken;

  UserModel({required this.user, required this.accessToken});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    user: User.fromJson(json["user"]),
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "access_token": accessToken,
  };

  UserModel copyWith({
    User? user,
    String? accessToken,
  }) {
    return UserModel(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

class User {
  String id;
  String firstName;
  String lastName;
  String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? '',
    firstName: json["first_name"] ?? '',
    lastName: json["last_name"] ?? '',
    email: json["email"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
  };
}
