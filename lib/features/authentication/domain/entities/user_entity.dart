import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String username;
  final String? photoUrl;

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, email, username, photoUrl];

  static const empty = UserEntity(id: '', email: '', username: '');

  bool get isEmpty => this == UserEntity.empty;
}
