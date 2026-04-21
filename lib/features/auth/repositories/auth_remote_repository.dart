import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, String>> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/api/v1/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password_hash": password,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return Right(result['message']);
      } else {
        final detail = result['detail'];

        final message = detail[0]['message'];
        return Left(AppFailure(message: message ?? 'Signup failed'));
      }
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/api/v1/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password_hash": password}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final token = result['access_token'] as String;

        final userResult = await getCurrentUser(token);
        return userResult;
      } else {
        final result = jsonDecode(response.body);
        return Left(AppFailure(message: result['detail'] ?? 'Signin failed'));
      }
    } catch (e) {
      debugPrint('$e');
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.serverUrl}/api/v1/auth/'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Backend returns flat user
        final user = UserModel.fromJson({
          'user': result,
          'access_token': token,
        });
        return Right(user);
      } else {
        return Left(
          AppFailure(message: result['detail'] ?? 'Failed to get user'),
        );
      }
    } catch (e) {
      debugPrint('$e');
      return Left(AppFailure(message: e.toString()));
    }
  }
}
