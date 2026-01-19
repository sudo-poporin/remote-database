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
