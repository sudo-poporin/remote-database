import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';

/// Interface para operaciones de autenticación.
abstract interface class IRemoteAuth {
  /// Inicia sesión con email y contraseña.
  Future<Either<RemoteAuthExceptions, User>> signInWithPassword({
    required String email,
    required String password,
  });

  /// Registra un nuevo usuario.
  Future<Either<RemoteAuthExceptions, User>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  });

  /// Cierra la sesión actual.
  Future<Either<RemoteAuthExceptions, void>> signOut();

  /// Inicia sesión con OAuth provider.
  Future<Either<RemoteAuthExceptions, void>> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
    List<String>? scopes,
  });

  /// Envía email para recuperar contraseña.
  Future<Either<RemoteAuthExceptions, void>> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  });

  /// Verifica un código OTP.
  Future<Either<RemoteAuthExceptions, User>> verifyOtp({
    required String token,
    required OtpType type,
    String? email,
    String? phone,
  });

  /// Actualiza la contraseña del usuario.
  Future<Either<RemoteAuthExceptions, User>> updatePassword({
    required String newPassword,
  });

  /// Actualiza los metadatos del usuario.
  Future<Either<RemoteAuthExceptions, User>> updateUserMetadata({
    required Map<String, dynamic> metadata,
  });

  /// Stream de cambios en el estado de autenticación.
  Stream<AuthState> get onAuthStateChange;

  /// Usuario actual o null si no hay sesión.
  User? get currentUser;

  /// Sesión actual o null si no hay sesión.
  Session? get currentSession;

  /// Verifica si hay un usuario autenticado.
  bool get isSignedIn;

  /// ID del usuario actual o null.
  String? get currentUserId;
}
