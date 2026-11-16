import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exceptions.freezed.dart';

/// Excepciones del módulo de autenticación.
@freezed
abstract class RemoteAuthExceptions
    with _$RemoteAuthExceptions
    implements Exception {
  /// Error al iniciar sesión.
  const factory signInFailure({required String message, int? statusCode}) =
      RemoteAuthSignInFailure;

  /// Error al registrarse.
  const factory signUpFailure({required String message, int? statusCode}) =
      RemoteAuthSignUpFailure;

  /// Error al cerrar sesión.
  const factory signOutFailure({required String message, int? statusCode}) =
      RemoteAuthSignOutFailure;

  /// Error al enviar email de recuperación.
  const factory passwordResetFailure({
    required String message,
    int? statusCode,
  }) = RemoteAuthPasswordResetFailure;

  /// Error al verificar OTP.
  const factory otpVerificationFailure({
    required String message,
    int? statusCode,
  }) = RemoteAuthOtpVerificationFailure;

  /// Error al actualizar usuario.
  const factory updateUserFailure({required String message, int? statusCode}) =
      RemoteAuthUpdateUserFailure;

  /// Credenciales inválidas.
  const factory invalidCredentials() = RemoteAuthInvalidCredentials;

  /// Email no confirmado.
  const factory emailNotConfirmed() = RemoteAuthEmailNotConfirmed;

  /// Usuario ya existe.
  const factory userAlreadyExists() = RemoteAuthUserAlreadyExists;

  /// Sesión expirada.
  const factory sessionExpired() = RemoteAuthSessionExpired;

  /// Error desconocido.
  const factory unknown({required String message}) = RemoteAuthUnknown;
}
