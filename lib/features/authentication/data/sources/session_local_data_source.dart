import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter_application/core/core.dart';

const String _authorizationTokenKey = 'authorization_token';

abstract class SessionLocalDataSource {
  Future<String?> getAuthorizationToken();
  Future<void> saveAuthorizationToken(String token);
  Future<void> clearAuthorizationToken();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  const SessionLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> clearAuthorizationToken() async {
    try {
      await _secureStorage.delete(key: _authorizationTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear authorization token: $e');
    }
  }

  @override
  Future<String?> getAuthorizationToken() async {
    try {
      return await _secureStorage.read(key: _authorizationTokenKey);
    } catch (e) {
      throw CacheException('Failed to read authorization token: $e');
    }
  }

  @override
  Future<void> saveAuthorizationToken(String token) async {
    try {
      await _secureStorage.write(key: _authorizationTokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to save authorization token: $e');
    }
  }
}
