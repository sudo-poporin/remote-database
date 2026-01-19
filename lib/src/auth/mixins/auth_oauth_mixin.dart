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
  }) async {
    try {
      await client.signInWithOAuth(
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
}
