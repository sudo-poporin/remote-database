import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_database_exceptions.freezed.dart';

/// Excepciones de la biblioteca de juegos.
@freezed
abstract class RemoteDatabaseExceptions
    with _$RemoteDatabaseExceptions
    implements Exception {
  /// Error al insertar un registro en la base de datos remota.
  const factory RemoteDatabaseExceptions.insertFailure([dynamic error]) =
      _RemoteDatabaseInsertFailure;

  /// Error al actualizar un registro en la base de datos remota.
  const factory RemoteDatabaseExceptions.updateFailure([dynamic error]) =
      _RemoteDatabaseUpdateFailure;

  /// Error al hacer un upsert en la base de datos remota.
  const factory RemoteDatabaseExceptions.upsertFailure([dynamic error]) =
      _RemoteDatabaseUpsertFailure;

  /// Error al eliminar un registro en la base de datos remota.
  const factory RemoteDatabaseExceptions.deleteFailure([dynamic error]) =
      _RemoteDatabaseDeleteFailure;

  /// Error al seleccionar registros de la base de datos remota.
  const factory RemoteDatabaseExceptions.selectFailure([dynamic error]) =
      _RemoteDatabaseSelectFailure;

  /// Error al seleccionar un registro de la base de datos remota.
  const factory RemoteDatabaseExceptions.selectSingleFailure([dynamic error]) =
      _RemoteDatabaseSelectSingleFailure;

  /// Error no se encuentra el registro en la base de datos remota.
  const factory RemoteDatabaseExceptions.noDataFound([dynamic error]) =
      _RemoteDatabaseNoDataFound;
}
