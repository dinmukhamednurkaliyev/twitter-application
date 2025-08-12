import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

final dioProvider = Provider<Dio>((ref) {
  const baseUrl = 'https://api.yourapp.com';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final localDataSource = ref.read(authLocalDataSourceProvider);
        final tokenResult = await localDataSource.getAuthenticationToken();

        tokenResult.fold(
          (failure) {
            handler.next(options);
          },
          (token) {
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
        );
      },
    ),
  );

  return dio;
});

final Provider<FlutterSecureStorage> flutterSecureStorageProvider = Provider(
  (ref) => const FlutterSecureStorage(),
);

final authRemoteDataSourceProvider = Provider<AuthenticationRemoteDataSource>((
  ref,
) {
  return AuthenticationRemoteDataSourceImplementation(
    dio: ref.watch(dioProvider),
  );
});

final authLocalDataSourceProvider = Provider<AuthenticationLocalDataSource>((
  ref,
) {
  return AuthenticationLocalDataSourceImplementation(
    secureStorage: ref.watch(flutterSecureStorageProvider),
  );
});

final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImplementation(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(
    repository: ref.watch(authRepositoryProvider),
  );
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(
    repository: ref.watch(authRepositoryProvider),
  );
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(
    repository: ref.watch(authRepositoryProvider),
  );
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(
    repository: ref.watch(authRepositoryProvider),
  );
});
