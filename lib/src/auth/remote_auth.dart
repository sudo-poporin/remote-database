import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';

/// Implementación de autenticación remota usando GoTrueClient.
class RemoteAuth implements IRemoteAuth {
  /// Crea una instancia de [RemoteAuth].
  RemoteAuth({required GoTrueClient client}) : _client = client;

  final GoTrueClient _client;

  @override
  Future<Either<RemoteAuthExceptions, User>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(RemoteAuthExceptions.invalidCredentials());
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(_mapAuthException(e, _AuthOperation.signIn));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, User>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _client.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.signUpFailure(message: 'User creation failed'),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        return const Left(RemoteAuthExceptions.userAlreadyExists());
      }
      return Left(_mapAuthException(e, _AuthOperation.signUp));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, void>> signOut() async {
    try {
      await _client.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(RemoteAuthExceptions.signOutFailure(message: e.message));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, void>> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
    List<String>? scopes,
  }) async {
    try {
      await _client.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
        scopes: scopes?.join(' '),
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.signInFailure(
          message: e.message,
          statusCode: int.tryParse(e.statusCode ?? ''),
        ),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, void>> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _client.resetPasswordForEmail(email, redirectTo: redirectTo);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.passwordResetFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, User>> verifyOtp({
    required String token,
    required OtpType type,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _client.verifyOTP(
        token: token,
        type: type,
        email: email,
        phone: phone,
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.otpVerificationFailure(
            message: 'OTP verification failed',
          ),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.otpVerificationFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, User>> updatePassword({
    required String newPassword,
  }) async {
    try {
      final response = await _client.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.updateUserFailure(
            message: 'Password update failed',
          ),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.updateUserFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<RemoteAuthExceptions, User>> updateUserMetadata({
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final response = await _client.updateUser(
        UserAttributes(data: metadata),
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.updateUserFailure(
            message: 'Metadata update failed',
          ),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.updateUserFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  @override
  Stream<AuthState> get onAuthStateChange => _client.onAuthStateChange;

  @override
  User? get currentUser => _client.currentUser;

  @override
  Session? get currentSession => _client.currentSession;

  @override
  bool get isSignedIn => _client.currentUser != null;

  @override
  String? get currentUserId => _client.currentUser?.id;

  RemoteAuthExceptions _mapAuthException(
    AuthException e,
    _AuthOperation operation,
  ) {
    final message = e.message;
    final statusCode = e.statusCode;

    if (message.contains('Invalid login credentials')) {
      return const RemoteAuthExceptions.invalidCredentials();
    }
    if (message.contains('Email not confirmed')) {
      return const RemoteAuthExceptions.emailNotConfirmed();
    }
    if (message.contains('already registered')) {
      return const RemoteAuthExceptions.userAlreadyExists();
    }

    return switch (operation) {
      _AuthOperation.signIn => RemoteAuthExceptions.signInFailure(
          message: message,
          statusCode: int.tryParse(statusCode ?? ''),
        ),
      _AuthOperation.signUp => RemoteAuthExceptions.signUpFailure(
          message: message,
          statusCode: int.tryParse(statusCode ?? ''),
        ),
    };
  }
}

enum _AuthOperation { signIn, signUp }
