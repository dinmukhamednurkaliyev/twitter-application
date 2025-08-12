import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.yourapp.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );
});

final authenticationDataSourceProvider =
    Provider<AuthenticationRemoteDataSource>((
      ref,
    ) {
      final dio = ref.watch(dioProvider);
      return AuthenticationRemoteDataSourceImplementation(dio: dio);
    });

final Provider<FlutterSecureStorage> flutterSecureStorageProvider = Provider(
  (ref) => const FlutterSecureStorage(),
);

final sessionLocalDataSourceProvider = Provider<AuthenticationLocalDataSource>((
  ref,
) {
  return AuthenticationLocalDataSourceImplmentation(
    secureStorage: ref.watch(flutterSecureStorageProvider),
  );
});

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((
  ref,
) {
  return AuthenticationRepositoryImplementation(
    remoteDataSource: ref.watch(authenticationDataSourceProvider),
    localDataSource: ref.watch(
      sessionLocalDataSourceProvider,
    ), // <<< Передаем новую зависимость
  );
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authenticationRepositoryProvider);
  return SignUpUseCase(repository: repository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authenticationRepositoryProvider);
  return SignInUseCase(repository: repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(
    repository: ref.watch(authenticationRepositoryProvider),
  );
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(
    repository: ref.watch(authenticationRepositoryProvider),
  );
});
