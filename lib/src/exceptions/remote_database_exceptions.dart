import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_database_exceptions.freezed.dart';

/// Excepciones del módulo de base de datos remota.
@freezed
abstract class RemoteDatabaseExceptions
    with _$RemoteDatabaseExceptions
    implements Exception {
  /// Error al insertar un registro en la base de datos remota.
  const factory insertFailure([dynamic error]) = _RemoteDatabaseInsertFailure;

  /// Error al actualizar un registro en la base de datos remota.
  const factory updateFailure([dynamic error]) = _RemoteDatabaseUpdateFailure;

  /// Error al hacer un upsert en la base de datos remota.
  const factory upsertFailure([dynamic error]) = _RemoteDatabaseUpsertFailure;

  /// Error al eliminar un registro en la base de datos remota.
  const factory deleteFailure([dynamic error]) = _RemoteDatabaseDeleteFailure;

  /// Error al seleccionar registros de la base de datos remota.
  const factory selectFailure([dynamic error]) = _RemoteDatabaseSelectFailure;

  /// Error al seleccionar un registro de la base de datos remota.
  const factory selectSingleFailure([dynamic error]) =
      _RemoteDatabaseSelectSingleFailure;

  /// Error no se encuentra el registro en la base de datos remota.
  const factory noDataFound() = RemoteDatabaseNoDataFound;
}
