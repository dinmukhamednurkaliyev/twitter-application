abstract class ApplicationException implements Exception {
  const ApplicationException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ServerException extends ApplicationException {
  const ServerException(super.message);
}

class NetworkException extends ApplicationException {
  const NetworkException(super.message);
}

class CacheException extends ApplicationException {
  const CacheException(super.message);
}

class InvalidCredentialsException extends ApplicationException {
  const InvalidCredentialsException(super.message);
}
