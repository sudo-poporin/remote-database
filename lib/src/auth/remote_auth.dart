import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/auth/mixins/auth_credentials_mixin.dart';
import 'package:remote_database/src/auth/mixins/auth_oauth_mixin.dart';
import 'package:remote_database/src/auth/mixins/auth_recovery_mixin.dart';
import 'package:remote_database/src/auth/mixins/auth_session_mixin.dart';
import 'package:remote_database/src/auth/mixins/auth_user_mixin.dart';
import 'package:remote_database/src/auth/remote_auth_base.dart';

/// Implementación de autenticación remota usando GoTrueClient.
///
/// Provee métodos para:
/// - Autenticación con credenciales (email/password)
/// - Autenticación OAuth (Google, Apple, GitHub, etc.)
/// - Recuperación de cuenta (password reset, OTP)
/// - Actualización de usuario (password, metadata)
/// - Manejo de sesión (refresh, recover, set)
///
/// Ejemplo de uso:
/// ```dart
/// final auth = RemoteAuth(client: supabase.auth);
///
/// // Sign in
/// final result = await auth.signInWithPassword(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// result.fold(
///   (error) => print('Error: $error'),
///   (user) => print('Welcome ${user.email}'),
/// );
/// ```
class RemoteAuth extends RemoteAuthBase
    with
        AuthCredentialsMixin,
        AuthOAuthMixin,
        AuthRecoveryMixin,
        AuthUserMixin,
        AuthSessionMixin
    implements IRemoteAuth {
  /// Crea una instancia de [RemoteAuth].
  RemoteAuth({required GoTrueClient goTrueClient}) : _client = goTrueClient;

  final GoTrueClient _client;

  // ===========================================================================
  // Implementación de RemoteAuthBase
  // ===========================================================================

  @override
  GoTrueClient get client => _client;

  @override
  RemoteAuthExceptions mapAuthException(
    AuthException e,
    AuthOperation operation,
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
      AuthOperation.signIn => RemoteAuthExceptions.signInFailure(
          message: message,
          statusCode: int.tryParse(statusCode ?? ''),
        ),
      AuthOperation.signUp => RemoteAuthExceptions.signUpFailure(
          message: message,
          statusCode: int.tryParse(statusCode ?? ''),
        ),
    };
  }
}
