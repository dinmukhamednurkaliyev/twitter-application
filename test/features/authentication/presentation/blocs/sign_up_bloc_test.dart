import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  group('RegisterBloc', () {
    late SignUpBloc registerBloc;
    late MockSignUpUseCase mockRegisterUseCase;

    const tEmail = 'test@example.com';
    const tUsername = 'testuser';
    const tPassword = 'strongPassword123';
    const tRegisterEvent = SignUpSubmitted(
      email: tEmail,
      username: tUsername,
      password: tPassword,
    );
    setUp(() {
      mockRegisterUseCase = MockSignUpUseCase();
      registerBloc = SignUpBloc(signUpUseCase: mockRegisterUseCase);
    });

    tearDown(() {
      registerBloc.close();
    });

    test('initial state is RegisterInitial', () {
      expect(registerBloc.state, const SignUpInitial());
    });

    group('on RegisterSubmitted', () {
      blocTest<SignUpBloc, SignUp>(
        'emits [RegisterLoading, RegisterLoadingSuccess] when registration is successful',
        setUp: () {
          when(
            () => mockRegisterUseCase(
              email: tEmail,
              username: tUsername,
              password: tPassword,
            ),
          ).thenAnswer((_) async => 'success');
        },
        build: () => registerBloc,
        act: (bloc) => bloc.add(tRegisterEvent),
        expect: () => <SignUp>[
          const SignUpLoading(),
          const SignInSuccess(),
        ],
        verify: (_) {
          verify(
            () => mockRegisterUseCase(
              email: tEmail,
              username: tUsername,
              password: tPassword,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUp>(
        'emits [RegisterLoading, RegisterLoadingFailure] when registration fails',
        setUp: () {
          when(
            () => mockRegisterUseCase(
              email: any(
                named: 'email',
              ),
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Email already in use'));
        },
        build: () => registerBloc,
        act: (bloc) => bloc.add(tRegisterEvent),
        expect: () => <SignUp>[
          const SignUpLoading(),
          const SignInFailure(
            message: 'Exception: Email already in use',
          ),
        ],
        verify: (_) {
          verify(
            () => mockRegisterUseCase(
              email: tEmail,
              username: tUsername,
              password: tPassword,
            ),
          ).called(1);
        },
      );
    });
  });
}
