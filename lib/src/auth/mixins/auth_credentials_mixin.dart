import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/auth/remote_auth_base.dart';

/// Mixin que provee métodos de autenticación con credenciales.
mixin AuthCredentialsMixin on RemoteAuthBase {
  /// Inicia sesión con email y contraseña.
  Future<Either<RemoteAuthExceptions, User>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(RemoteAuthExceptions.invalidCredentials());
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(mapAuthException(e, AuthOperation.signIn));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Registra un nuevo usuario.
  Future<Either<RemoteAuthExceptions, User>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await client.signUp(
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
      return Left(mapAuthException(e, AuthOperation.signUp));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Cierra la sesión actual.
  Future<Either<RemoteAuthExceptions, void>> signOut() async {
    try {
      await client.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(RemoteAuthExceptions.signOutFailure(message: e.message));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }
}
