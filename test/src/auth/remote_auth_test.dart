import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:remote_database/remote_database.dart';

import '../../dependencies/mock_runner_test.mocks.dart';

void main() {
  late MockGoTrueClient mockClient;
  late RemoteAuth auth;

  // Test fixtures - JSON representations for fromJson constructors
  final userJson = {
    'id': 'test-user-id',
    'app_metadata': <String, dynamic>{},
    'user_metadata': {'name': 'Test User'},
    'aud': 'authenticated',
    'created_at': DateTime.now().toIso8601String(),
  };

  final testUser = User.fromJson(userJson)!;

  final testSession = Session(
    accessToken: 'test-access-token',
    tokenType: 'bearer',
    user: testUser,
  );

  // UserResponse.fromJson expects user JSON directly (not nested)
  final userResponseJson = userJson;

  // JSON without 'id' results in User.fromJson returning null
  final emptyUserJson = <String, dynamic>{};

  setUp(() {
    mockClient = MockGoTrueClient();
    auth = RemoteAuth(goTrueClient: mockClient);
  });

  group('RemoteAuth - signInWithPassword', () {
    test('returns Right(User) on successful sign in', () async {
      when(
        mockClient.signInWithPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: testUser, session: testSession),
      );

      final result = await auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (user) => expect(user.id, equals('test-user-id')),
      );
    });

    test('returns Left(invalidCredentials) when user is null', () async {
      when(
        mockClient.signInWithPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => AuthResponse());

      final result = await auth.signInWithPassword(
        email: 'test@example.com',
        password: 'wrong-password',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthInvalidCredentials>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test(
      'returns Left(invalidCredentials) on invalid login credentials',
      () async {
        when(
          mockClient.signInWithPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(
          const AuthException('Invalid login credentials', statusCode: '400'),
        );

        final result = await auth.signInWithPassword(
          email: 'test@example.com',
          password: 'wrong-password',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, isA<RemoteAuthInvalidCredentials>()),
          (r) => fail('Expected Left but got Right'),
        );
      },
    );

    test('returns Left(emailNotConfirmed) when email not confirmed', () async {
      when(
        mockClient.signInWithPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(
        const AuthException('Email not confirmed', statusCode: '400'),
      );

      final result = await auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthEmailNotConfirmed>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(signInFailure) on generic AuthException', () async {
      when(
        mockClient.signInWithPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(const AuthException('Some other error', statusCode: '500'));

      final result = await auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthSignInFailure>());
          final failure = error as RemoteAuthSignInFailure;
          expect(failure.message, equals('Some other error'));
          expect(failure.statusCode, equals(500));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(
        mockClient.signInWithPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(Exception('Network error'));

      final result = await auth.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - signUp', () {
    test('returns Right(User) on successful sign up', () async {
      when(
        mockClient.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: testUser, session: testSession),
      );

      final result = await auth.signUp(
        email: 'new@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (user) => expect(user.id, equals('test-user-id')),
      );
    });

    test('returns Right(User) with metadata', () async {
      final metadata = {
        'name': 'John Doe',
        'avatar': 'http://example.com/avatar.png',
      };

      when(
        mockClient.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: testUser, session: testSession),
      );

      final result = await auth.signUp(
        email: 'new@example.com',
        password: 'password123',
        metadata: metadata,
      );

      expect(result.isRight(), isTrue);
      verify(
        mockClient.signUp(
          email: 'new@example.com',
          password: 'password123',
          data: metadata,
        ),
      ).called(1);
    });

    test('returns Left(signUpFailure) when user is null', () async {
      when(
        mockClient.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => AuthResponse());

      final result = await auth.signUp(
        email: 'new@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthSignUpFailure>());
          final failure = error as RemoteAuthSignUpFailure;
          expect(failure.message, equals('User creation failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test(
      'returns Left(userAlreadyExists) when email already registered',
      () async {
        when(
          mockClient.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
            data: anyNamed('data'),
          ),
        ).thenThrow(
          const AuthException('User already registered', statusCode: '400'),
        );

        final result = await auth.signUp(
          email: 'existing@example.com',
          password: 'password123',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (error) => expect(error, isA<RemoteAuthUserAlreadyExists>()),
          (r) => fail('Expected Left but got Right'),
        );
      },
    );

    test('returns Left(signUpFailure) on generic AuthException', () async {
      when(
        mockClient.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          data: anyNamed('data'),
        ),
      ).thenThrow(const AuthException('Some other error', statusCode: '500'));

      final result = await auth.signUp(
        email: 'new@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthSignUpFailure>());
          final failure = error as RemoteAuthSignUpFailure;
          expect(failure.message, equals('Some other error'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(
        mockClient.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          data: anyNamed('data'),
        ),
      ).thenThrow(Exception('Network error'));

      final result = await auth.signUp(
        email: 'new@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - signOut', () {
    test('returns Right(null) on successful sign out', () async {
      when(mockClient.signOut()).thenAnswer((_) async {});

      final result = await auth.signOut();

      expect(result.isRight(), isTrue);
      verify(mockClient.signOut()).called(1);
    });

    test('returns Left(signOutFailure) on AuthException', () async {
      when(mockClient.signOut()).thenThrow(
        const AuthException('Sign out failed', statusCode: '500'),
      );

      final result = await auth.signOut();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthSignOutFailure>());
          final failure = error as RemoteAuthSignOutFailure;
          expect(failure.message, equals('Sign out failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockClient.signOut()).thenThrow(Exception('Network error'));

      final result = await auth.signOut();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  // Note: signInWithOAuth tests omitted because the method is an extension
  // from supabase_flutter, not a direct GoTrueClient method. Extensions cannot
  // be mocked with mockito. OAuth flows require browser interaction and are
  // better tested via integration tests.

  group('RemoteAuth - sendPasswordResetEmail', () {
    test('returns Right(null) on success', () async {
      when(
        mockClient.resetPasswordForEmail(
          any,
          redirectTo: anyNamed('redirectTo'),
        ),
      ).thenAnswer((_) async {});

      final result = await auth.sendPasswordResetEmail(
        email: 'test@example.com',
        redirectTo: 'myapp://reset',
      );

      expect(result.isRight(), isTrue);
      verify(
        mockClient.resetPasswordForEmail(
          'test@example.com',
          redirectTo: 'myapp://reset',
        ),
      ).called(1);
    });

    test('returns Left(passwordResetFailure) on AuthException', () async {
      when(
        mockClient.resetPasswordForEmail(
          any,
          redirectTo: anyNamed('redirectTo'),
        ),
      ).thenThrow(const AuthException('User not found', statusCode: '404'));

      final result = await auth.sendPasswordResetEmail(
        email: 'unknown@example.com',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthPasswordResetFailure>());
          final failure = error as RemoteAuthPasswordResetFailure;
          expect(failure.message, equals('User not found'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(
        mockClient.resetPasswordForEmail(
          any,
          redirectTo: anyNamed('redirectTo'),
        ),
      ).thenThrow(Exception('Network error'));

      final result = await auth.sendPasswordResetEmail(
        email: 'test@example.com',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - verifyOtp', () {
    test('returns Right(User) on successful verification', () async {
      when(
        mockClient.verifyOTP(
          token: anyNamed('token'),
          type: anyNamed('type'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
        ),
      ).thenAnswer(
        (_) async => AuthResponse(user: testUser, session: testSession),
      );

      final result = await auth.verifyOtp(
        token: '123456',
        type: OtpType.signup,
        email: 'test@example.com',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (user) => expect(user.id, equals('test-user-id')),
      );
    });

    test('returns Left(otpVerificationFailure) when user is null', () async {
      when(
        mockClient.verifyOTP(
          token: anyNamed('token'),
          type: anyNamed('type'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
        ),
      ).thenAnswer((_) async => AuthResponse());

      final result = await auth.verifyOtp(
        token: '000000',
        type: OtpType.signup,
        email: 'test@example.com',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthOtpVerificationFailure>());
          final failure = error as RemoteAuthOtpVerificationFailure;
          expect(failure.message, equals('OTP verification failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(otpVerificationFailure) on AuthException', () async {
      when(
        mockClient.verifyOTP(
          token: anyNamed('token'),
          type: anyNamed('type'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
        ),
      ).thenThrow(const AuthException('Invalid OTP', statusCode: '400'));

      final result = await auth.verifyOtp(
        token: 'wrong-token',
        type: OtpType.recovery,
        email: 'test@example.com',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthOtpVerificationFailure>());
          final failure = error as RemoteAuthOtpVerificationFailure;
          expect(failure.message, equals('Invalid OTP'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(
        mockClient.verifyOTP(
          token: anyNamed('token'),
          type: anyNamed('type'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
        ),
      ).thenThrow(Exception('Network error'));

      final result = await auth.verifyOtp(
        token: '123456',
        type: OtpType.signup,
        email: 'test@example.com',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - updatePassword', () {
    test('returns Right(User) on successful update', () async {
      when(mockClient.updateUser(any)).thenAnswer(
        (_) async => UserResponse.fromJson(userResponseJson),
      );

      final result = await auth.updatePassword(newPassword: 'newPassword123');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (user) => expect(user.id, equals('test-user-id')),
      );
    });

    test('returns Left(updateUserFailure) when user is null', () async {
      when(mockClient.updateUser(any)).thenAnswer(
        (_) async => UserResponse.fromJson(emptyUserJson),
      );

      final result = await auth.updatePassword(newPassword: 'newPassword123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthUpdateUserFailure>());
          final failure = error as RemoteAuthUpdateUserFailure;
          expect(failure.message, equals('Password update failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(updateUserFailure) on AuthException', () async {
      when(mockClient.updateUser(any)).thenThrow(
        const AuthException('Password too weak', statusCode: '400'),
      );

      final result = await auth.updatePassword(newPassword: '123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthUpdateUserFailure>());
          final failure = error as RemoteAuthUpdateUserFailure;
          expect(failure.message, equals('Password too weak'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockClient.updateUser(any)).thenThrow(Exception('Network error'));

      final result = await auth.updatePassword(newPassword: 'newPassword123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - updateUserMetadata', () {
    test('returns Right(User) on successful update', () async {
      when(mockClient.updateUser(any)).thenAnswer(
        (_) async => UserResponse.fromJson(userResponseJson),
      );

      final result = await auth.updateUserMetadata(
        metadata: {'avatar_url': 'http://example.com/avatar.png'},
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (user) => expect(user.id, equals('test-user-id')),
      );
    });

    test('returns Left(updateUserFailure) when user is null', () async {
      when(mockClient.updateUser(any)).thenAnswer(
        (_) async => UserResponse.fromJson(emptyUserJson),
      );

      final result = await auth.updateUserMetadata(metadata: {'key': 'value'});

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthUpdateUserFailure>());
          final failure = error as RemoteAuthUpdateUserFailure;
          expect(failure.message, equals('Metadata update failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(updateUserFailure) on AuthException', () async {
      when(mockClient.updateUser(any)).thenThrow(
        const AuthException('Update failed', statusCode: '500'),
      );

      final result = await auth.updateUserMetadata(metadata: {'key': 'value'});

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthUpdateUserFailure>());
          final failure = error as RemoteAuthUpdateUserFailure;
          expect(failure.message, equals('Update failed'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockClient.updateUser(any)).thenThrow(Exception('Network error'));

      final result = await auth.updateUserMetadata(metadata: {'key': 'value'});

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - refreshSession', () {
    test('returns Right(Session) on successful refresh', () async {
      when(mockClient.refreshSession()).thenAnswer(
        (_) async => AuthResponse(user: testUser, session: testSession),
      );

      final result = await auth.refreshSession();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (session) => expect(session.accessToken, equals('test-access-token')),
      );
    });

    test('returns Left(sessionExpired) when session is null', () async {
      when(mockClient.refreshSession()).thenAnswer(
        (_) async => AuthResponse(),
      );

      final result = await auth.refreshSession();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthSessionExpired>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(sessionExpired) on expired token', () async {
      when(mockClient.refreshSession()).thenThrow(
        const AuthException('Token expired', statusCode: '401'),
      );

      final result = await auth.refreshSession();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthSessionExpired>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(sessionExpired) on invalid token', () async {
      when(mockClient.refreshSession()).thenThrow(
        const AuthException('Token is invalid', statusCode: '401'),
      );

      final result = await auth.refreshSession();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthSessionExpired>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on generic AuthException', () async {
      when(mockClient.refreshSession()).thenThrow(
        const AuthException('Server error', statusCode: '500'),
      );

      final result = await auth.refreshSession();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockClient.refreshSession()).thenThrow(Exception('Network error'));

      final result = await auth.refreshSession();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - recoverSession', () {
    test('returns Right(Session) when session exists', () async {
      when(mockClient.currentSession).thenReturn(testSession);

      final result = await auth.recoverSession();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (session) => expect(session?.accessToken, equals('test-access-token')),
      );
    });

    test('returns Right(null) when no session exists', () async {
      when(mockClient.currentSession).thenReturn(null);

      final result = await auth.recoverSession();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (session) => expect(session, isNull),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockClient.currentSession).thenThrow(Exception('Storage error'));

      final result = await auth.recoverSession();

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - setSession', () {
    test('returns Right(null) on successful set', () async {
      when(mockClient.setSession(any)).thenAnswer(
        (_) async => AuthResponse(user: testUser, session: testSession),
      );

      final result = await auth.setSession('new-access-token');

      expect(result.isRight(), isTrue);
      verify(mockClient.setSession('new-access-token')).called(1);
    });

    test('returns Left(unknown) on AuthException', () async {
      when(mockClient.setSession(any)).thenThrow(
        const AuthException('Invalid token', statusCode: '400'),
      );

      final result = await auth.setSession('invalid-token');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) {
          expect(error, isA<RemoteAuthUnknown>());
          final unknown = error as RemoteAuthUnknown;
          expect(unknown.message, equals('Invalid token'));
        },
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('returns Left(unknown) on unexpected exception', () async {
      when(mockClient.setSession(any)).thenThrow(Exception('Network error'));

      final result = await auth.setSession('token');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<RemoteAuthUnknown>()),
        (r) => fail('Expected Left but got Right'),
      );
    });
  });

  group('RemoteAuth - getters', () {
    test('onAuthStateChange returns stream from client', () async {
      final controller = StreamController<AuthState>.broadcast();
      when(mockClient.onAuthStateChange).thenAnswer((_) => controller.stream);

      final stream = auth.onAuthStateChange;

      expect(stream, isA<Stream<AuthState>>());
      await controller.close();
    });

    test('currentUser returns user from client', () {
      when(mockClient.currentUser).thenReturn(testUser);

      final user = auth.currentUser;

      expect(user, equals(testUser));
      expect(user?.id, equals('test-user-id'));
    });

    test('currentUser returns null when no user', () {
      when(mockClient.currentUser).thenReturn(null);

      final user = auth.currentUser;

      expect(user, isNull);
    });

    test('currentSession returns session from client', () {
      when(mockClient.currentSession).thenReturn(testSession);

      final session = auth.currentSession;

      expect(session, equals(testSession));
      expect(session?.accessToken, equals('test-access-token'));
    });

    test('currentSession returns null when no session', () {
      when(mockClient.currentSession).thenReturn(null);

      final session = auth.currentSession;

      expect(session, isNull);
    });

    test('isSignedIn returns true when user exists', () {
      when(mockClient.currentUser).thenReturn(testUser);

      final result = auth.isSignedIn;

      expect(result, isTrue);
    });

    test('isSignedIn returns false when no user', () {
      when(mockClient.currentUser).thenReturn(null);

      final result = auth.isSignedIn;

      expect(result, isFalse);
    });

    test('currentUserId returns user id when user exists', () {
      when(mockClient.currentUser).thenReturn(testUser);

      final userId = auth.currentUserId;

      expect(userId, equals('test-user-id'));
    });

    test('currentUserId returns null when no user', () {
      when(mockClient.currentUser).thenReturn(null);

      final userId = auth.currentUserId;

      expect(userId, isNull);
    });
  });
}
