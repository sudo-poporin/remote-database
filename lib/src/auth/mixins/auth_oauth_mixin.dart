import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/auth/remote_auth_base.dart';

/// Mixin que provee métodos de autenticación OAuth.
mixin AuthOAuthMixin on RemoteAuthBase {
  /// Inicia sesión con OAuth provider.
  Future<Either<RemoteAuthExceptions, void>> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
    List<String>? scopes,
    Map<String, String>? queryParams,
  }) async {
    try {
      await client.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
        scopes: scopes?.join(' '),
        queryParams: queryParams,
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

  /// Inicia sesión con un `idToken` obtenido por el SDK nativo del proveedor.
  ///
  /// Es el camino de un login nativo (por ejemplo, el selector de cuentas de
  /// Google del sistema): el SDK entrega el token y Supabase lo cambia por una
  /// sesión. Una respuesta sin usuario es un `signInFailure`, igual que una
  /// `AuthException`.
  Future<Either<RemoteAuthExceptions, User>> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
  }) async {
    try {
      final response = await client.signInWithIdToken(
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
        nonce: nonce,
      );

      final user = response.user;
      if (user == null) {
        return const Left(
          RemoteAuthExceptions.signInFailure(message: 'No user in response'),
        );
      }

      return Right(user);
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
}
