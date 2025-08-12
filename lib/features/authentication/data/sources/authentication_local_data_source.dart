import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter_application/core/core.dart';

const String _authenticationTokenKey = 'authorization_token';

abstract class AuthenticationLocalDataSource {
  Future<String?> getAuthenticationToken();
  Future<void> saveAuthenticationToken(String token);
  Future<void> clearAuthenticationToken();
}

class AuthenticationLocalDataSourceImplmentation
    implements AuthenticationLocalDataSource {
  const AuthenticationLocalDataSourceImplmentation({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> clearAuthenticationToken() async {
    try {
      await _secureStorage.delete(key: _authenticationTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear authorization token: $e');
    }
  }

  @override
  Future<String?> getAuthenticationToken() async {
    try {
      return await _secureStorage.read(key: _authenticationTokenKey);
    } catch (e) {
      throw CacheException('Failed to read authorization token: $e');
    }
  }

  @override
  Future<void> saveAuthenticationToken(String token) async {
    try {
      await _secureStorage.write(key: _authenticationTokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to save authorization token: $e');
    }
  }
}
