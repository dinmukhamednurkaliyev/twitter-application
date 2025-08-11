import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitter_application/features/authentication/domain/entities/user_entity.dart';
import 'package:twitter_application/features/authentication/domain/repositories/authentication_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late UserEntity userEntity;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    userEntity = const UserEntity(
      email: 'test@test.com',
      username: 'testuser',
      password: 'password',
    );
  });

  group('AuthenticationRepository', () {
    group('signUp', () {
      test('should return a user ID when signUp is successful', () async {
        when(
          () => mockAuthenticationRepository.signUp(user: userEntity),
        ).thenAnswer((_) async => 'user_id');

        final result = await mockAuthenticationRepository.signUp(
          user: userEntity,
        );

        expect(result, 'user_id');
        verify(
          () => mockAuthenticationRepository.signUp(user: userEntity),
        ).called(1);
      });

      test('should throw an exception when signUp fails', () async {
        final exception = Exception('Sign up failed');
        when(
          () => mockAuthenticationRepository.signUp(user: userEntity),
        ).thenThrow(exception);

        final call = mockAuthenticationRepository.signUp;

        expect(() => call(user: userEntity), throwsA(isA<Exception>()));
        verify(
          () => mockAuthenticationRepository.signUp(user: userEntity),
        ).called(1);
      });
    });

    group('signIn', () {
      test('should return a user ID when signIn is successful', () async {
        when(
          () => mockAuthenticationRepository.signIn(user: userEntity),
        ).thenAnswer((_) async => 'user_id');

        final result = await mockAuthenticationRepository.signIn(
          user: userEntity,
        );

        expect(result, 'user_id');
        verify(
          () => mockAuthenticationRepository.signIn(user: userEntity),
        ).called(1);
      });

      test('should throw an exception when signIn fails', () async {
        final exception = Exception('Sign in failed');
        when(
          () => mockAuthenticationRepository.signIn(user: userEntity),
        ).thenThrow(exception);

        final call = mockAuthenticationRepository.signIn;

        expect(() => call(user: userEntity), throwsA(isA<Exception>()));
        verify(
          () => mockAuthenticationRepository.signIn(user: userEntity),
        ).called(1);
      });
    });
  });
}
