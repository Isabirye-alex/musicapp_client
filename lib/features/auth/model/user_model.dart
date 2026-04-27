
class UserModel {
  /// The authenticated user
  User user;

  /// JWT access token for API authentication
  String accessToken;

  UserModel({required this.user, required this.accessToken});

  /// Creates UserModel from JSON response
  /// [json] - Map containing 'user' and 'access_token' keys
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    user: User.fromJson(json["user"]),
    accessToken: json["access_token"],
  );

  /// Converts UserModel to JSON for API requests
  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "access_token": accessToken,
  };

  /// Creates a copy with optional field overrides
  UserModel copyWith({User? user, String? accessToken}) {
    return UserModel(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

/// User data model representing app users
class User {
  /// Unique user identifier
  String id;

  /// User's first name
  String firstName;

  /// User's last name
  String lastName;

  /// User's email address
  String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  /// Creates User from JSON response
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? '',
    firstName: json["first_name"] ?? '',
    lastName: json["last_name"] ?? '',
    email: json["email"] ?? '',
  );

  /// Converts User to JSON for API requests
  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
  };
}
