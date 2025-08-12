import 'package:flutter/foundation.dart';

@immutable
abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifLeft(value);
  }
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifRight(value);
  }
}
