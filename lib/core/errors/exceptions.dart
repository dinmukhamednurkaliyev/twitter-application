import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Failure extends Equatable implements Exception {
  const Failure({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}
