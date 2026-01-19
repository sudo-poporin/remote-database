import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/auth/remote_auth_base.dart';

/// Mixin que provee métodos de recuperación de cuenta.
mixin AuthRecoveryMixin on RemoteAuthBase {
  /// Envía email para recuperar contraseña.
  Future<Either<RemoteAuthExceptions, void>> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await client.resetPasswordForEmail(email, redirectTo: redirectTo);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.passwordResetFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Verifica un código OTP.
  Future<Either<RemoteAuthExceptions, User>> verifyOtp({
    required String token,
    required OtpType type,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await client.verifyOTP(
        token: token,
        type: type,
        email: email,
        phone: phone,
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.otpVerificationFailure(
            message: 'OTP verification failed',
          ),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.otpVerificationFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }
}
