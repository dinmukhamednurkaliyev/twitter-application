import 'package:flutter/foundation.dart';
import 'package:twitter_application/features/authentication/data/models/user_model.dart';

@immutable
class AuthenticationResponseModel {
  const AuthenticationResponseModel({required this.token, required this.user});

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponseModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final String token;
  final UserModel user;
}
