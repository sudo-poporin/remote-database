import 'package:remote_database/remote_database.dart';

/// Clase base abstracta para RemoteAuth.
///
/// Define los campos y métodos compartidos que los mixins necesitan.
abstract class RemoteAuthBase {
  /// Cliente de autenticación de Supabase.
  GoTrueClient get client;

  /// Mapea excepciones de autenticación a tipos específicos.
  RemoteAuthExceptions mapAuthException(
    AuthException e,
    AuthOperation operation,
  );
}

/// Operaciones de autenticación para mapeo de excepciones.
enum AuthOperation {
  /// Inicio de sesión.
  signIn,

  /// Registro.
  signUp,
}
