import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter_application/core/core.dart';

const String _authenticationTokenKey = 'authorization_token';

abstract class AuthenticationLocalDataSource {
  Future<Either<Failure, String?>> getAuthenticationToken();

  Future<Either<Failure, void>> saveAuthenticationToken(String token);
  Future<Either<Failure, void>> clearAuthenticationToken();
}

class AuthenticationLocalDataSourceImplmentation
    implements AuthenticationLocalDataSource {
  const AuthenticationLocalDataSourceImplmentation({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<Either<Failure, void>> clearAuthenticationToken() async {
    try {
      await _secureStorage.delete(key: _authenticationTokenKey);

      return const Right(null);
    } on Exception catch (e) {
      return Left(
        CacheFailure(message: 'Failed to clear authorization token: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthenticationToken() async {
    try {
      final token = await _secureStorage.read(key: _authenticationTokenKey);

      return Right(token);
    } on Exception catch (e) {
      return Left(
        CacheFailure(message: 'Failed to read authorization token: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthenticationToken(String token) async {
    try {
      await _secureStorage.write(key: _authenticationTokenKey, value: token);

      return const Right(null);
    } on Exception catch (e) {
      return Left(
        CacheFailure(message: 'Failed to save authorization token: $e'),
      );
    }
  }
}
