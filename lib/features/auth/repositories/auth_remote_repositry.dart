import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:little_music/core/constants/server_constants.dart';
import 'package:little_music/core/failure/failure.dart';
import 'package:little_music/features/auth/model/user_model.dart';

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverurl}/api/v1/auth/signup'),
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
        final user = UserModel.fromJson(result);
        return Right(user);
      } else {
        return Left(AppFailure(message: result['detail'] ?? 'Signup failed'));
      }
    } catch (e) {
      debugPrint('$e.toString()');
      return Left(AppFailure());
    }
  }

  Future<Either<AppFailure, UserModel>> signin(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverurl}/api/v1/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password_hash": password}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(result);
        return Right(user);
      } else {
        return Left(AppFailure(message: result['detail'] ?? 'Signin failed'));
      }
    } catch (e) {
      debugPrint('$e.toString()');
      return Left(AppFailure());
    }
  }
}
