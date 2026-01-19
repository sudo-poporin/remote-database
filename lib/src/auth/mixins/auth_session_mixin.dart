import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/auth/remote_auth_base.dart';

/// Mixin que provee métodos de manejo de sesión.
mixin AuthSessionMixin on RemoteAuthBase {
  /// Refresca la sesión actual.
  Future<Either<RemoteAuthExceptions, Session>> refreshSession() async {
    try {
      final response = await client.refreshSession();

      if (response.session == null) {
        return const Left(RemoteAuthExceptions.sessionExpired());
      }

      return Right(response.session!);
    } on AuthException catch (e) {
      if (e.message.contains('expired') || e.message.contains('invalid')) {
        return const Left(RemoteAuthExceptions.sessionExpired());
      }
      return Left(RemoteAuthExceptions.unknown(message: e.message));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Recupera la sesión almacenada.
  Future<Either<RemoteAuthExceptions, Session?>> recoverSession() async {
    try {
      final session = client.currentSession;
      return Right(session);
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Establece una sesión manualmente.
  Future<Either<RemoteAuthExceptions, void>> setSession(
    String accessToken,
  ) async {
    try {
      await client.setSession(accessToken);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.message));
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Stream de cambios en el estado de autenticación.
  Stream<AuthState> get onAuthStateChange => client.onAuthStateChange;

  /// Usuario actual o null si no hay sesión.
  User? get currentUser => client.currentUser;

  /// Sesión actual o null si no hay sesión.
  Session? get currentSession => client.currentSession;

  /// Verifica si hay un usuario autenticado.
  bool get isSignedIn => client.currentUser != null;

  /// ID del usuario actual o null.
  String? get currentUserId => client.currentUser?.id;
}
