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
