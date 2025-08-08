import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  group('RegisterUseCase', () {
    late RegisterUseCase useCase;
    late MockAuthenticationRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthenticationRepository();
      useCase = RegisterUseCase(authenticationRepository: mockRepository);
    });

    const tEmail = 'test@mail.com';
    const tUsername = 'testuser';
    const tPassword = 'password123';
    const tToken = '_super_secret_auth_token_';

    const tUserEntity = UserEntity(
      email: tEmail,
      username: tUsername,
      password: tPassword,
    );

    test(
      'should call authenticationRepository.register and return token successfully',
      () async {
        // ARRANGE
        when(
          () => mockRepository.register(user: tUserEntity),
        ).thenAnswer((_) async => tToken);

        // ACT
        final result = await useCase(
          email: tEmail,
          username: tUsername,
          password: tPassword,
        );

        // ASSERT
        expect(result, tToken);
        verify(() => mockRepository.register(user: tUserEntity)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should throw an exception when repository throws an exception',
      () async {
        final tException = Exception('Email already exists');
        when(
          () => mockRepository.register(user: any(named: 'user')),
        ).thenThrow(tException);

        // ACT
        final call = useCase.call;

        // ASSERT
        expect(
          () => call(email: tEmail, username: tUsername, password: tPassword),
          throwsA(isA<Exception>()),
        );

        verify(() => mockRepository.register(user: tUserEntity)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
