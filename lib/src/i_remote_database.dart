import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';

/// Repositorio de base de datos remota.
abstract interface class IRemoteDatabase {
  /// Realiza una consulta a la base de datos y devuelve una lista de registros.
  Future<Either<RemoteDatabaseExceptions, List<Map<String, dynamic>>>>
  selectFrom({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
  });

  /// Realiza una consulta a la base de datos y devuelve un solo registro.
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>>> selectSingle({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
  });

  /// Inserta o actualiza un registro en la base de datos.
  Future<Either<RemoteDatabaseExceptions, void>> upsert({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
  });

  /// Insterta un registro en la base de datos y devuelve el id del registro.
  Future<Either<RemoteDatabaseExceptions, int>> insert({
    required String table,
    required Map<String, dynamic> data,
    String resultIdColumn = 'id',
  });

  /// Actualiza un registro en la base de datos.
  Future<Either<RemoteDatabaseExceptions, int>> update({
    required String table,
    required Map<dynamic, dynamic> values,
    required Map<String, Object> where,
    String resultIdColumn = 'id',
  });

  /// Elimina un registro en la base de datos.
  Future<Either<RemoteDatabaseExceptions, void>> delete({
    required String table,
    required Map<String, Object> where,
  });
}
