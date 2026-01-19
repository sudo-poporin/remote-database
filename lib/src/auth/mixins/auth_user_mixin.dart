import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/auth/remote_auth_base.dart';

/// Mixin que provee métodos de actualización de usuario.
mixin AuthUserMixin on RemoteAuthBase {
  /// Actualiza la contraseña del usuario.
  Future<Either<RemoteAuthExceptions, User>> updatePassword({
    required String newPassword,
  }) async {
    try {
      final response = await client.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.updateUserFailure(
            message: 'Password update failed',
          ),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.updateUserFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }

  /// Actualiza los metadatos del usuario.
  Future<Either<RemoteAuthExceptions, User>> updateUserMetadata({
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final response = await client.updateUser(
        UserAttributes(data: metadata),
      );

      if (response.user == null) {
        return const Left(
          RemoteAuthExceptions.updateUserFailure(
            message: 'Metadata update failed',
          ),
        );
      }

      return Right(response.user!);
    } on AuthException catch (e) {
      return Left(
        RemoteAuthExceptions.updateUserFailure(message: e.message),
      );
    } on Object catch (e) {
      return Left(RemoteAuthExceptions.unknown(message: e.toString()));
    }
  }
}
