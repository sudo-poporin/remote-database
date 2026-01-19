import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exceptions.freezed.dart';

/// Excepciones del módulo de autenticación.
@freezed
abstract class RemoteAuthExceptions
    with _$RemoteAuthExceptions
    implements Exception {
  /// Error al iniciar sesión.
  const factory RemoteAuthExceptions.signInFailure({
    required String message,
    int? statusCode,
  }) = RemoteAuthSignInFailure;

  /// Error al registrarse.
  const factory RemoteAuthExceptions.signUpFailure({
    required String message,
    int? statusCode,
  }) = RemoteAuthSignUpFailure;

  /// Error al cerrar sesión.
  const factory RemoteAuthExceptions.signOutFailure({
    required String message,
  }) = RemoteAuthSignOutFailure;

  /// Error al enviar email de recuperación.
  const factory RemoteAuthExceptions.passwordResetFailure({
    required String message,
  }) = RemoteAuthPasswordResetFailure;

  /// Error al verificar OTP.
  const factory RemoteAuthExceptions.otpVerificationFailure({
    required String message,
  }) = RemoteAuthOtpVerificationFailure;

  /// Error al actualizar usuario.
  const factory RemoteAuthExceptions.updateUserFailure({
    required String message,
  }) = RemoteAuthUpdateUserFailure;

  /// Credenciales inválidas.
  const factory RemoteAuthExceptions.invalidCredentials() =
      RemoteAuthInvalidCredentials;

  /// Email no confirmado.
  const factory RemoteAuthExceptions.emailNotConfirmed() =
      RemoteAuthEmailNotConfirmed;

  /// Usuario ya existe.
  const factory RemoteAuthExceptions.userAlreadyExists() =
      RemoteAuthUserAlreadyExists;

  /// Sesión expirada.
  const factory RemoteAuthExceptions.sessionExpired() =
      RemoteAuthSessionExpired;

  /// Error desconocido.
  const factory RemoteAuthExceptions.unknown({
    required String message,
  }) = RemoteAuthUnknown;
}
