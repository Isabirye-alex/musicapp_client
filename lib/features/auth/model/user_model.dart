// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? accessToken;

  const UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.userId,
    this.accessToken
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password_hash': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      accessToken: json['access_token'] ?? ''
    );
  }
}
