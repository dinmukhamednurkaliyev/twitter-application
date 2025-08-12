import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(baseUrl: 'http://192.168.0.104:8000'),
  );
});

final authenticationDataSourceProvider = Provider<AuthenticationDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return AuthenticationDataSourceImplementation(dio: dio);
});

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(authenticationDataSourceProvider);
  return AuthenticationRepositoryImplementation(
    remoteDataSource: remoteDataSource,
  );
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authenticationRepositoryProvider);
  return SignUpUseCase(authenticationRepository: repository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authenticationRepositoryProvider);
  return SignInUseCase(authenticationRepository: repository);
});
