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
    String? schema,
  });

  /// Realiza una consulta a la base de datos y devuelve un solo registro.
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>>> selectSingle({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
    String? schema,
  });

  /// Inserta o actualiza un registro en la base de datos.
  Future<Either<RemoteDatabaseExceptions, void>> upsert({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
    String? schema,
  });

  /// Insterta un registro en la base de datos y devuelve el id del registro.
  Future<Either<RemoteDatabaseExceptions, int>> insert({
    required String table,
    required Map<String, dynamic> data,
    String resultIdColumn = 'id',
    String? schema,
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
    String? schema,
  });

  /// Crea un QueryBuilder para consultas avanzadas.
  ///
  /// Permite construir consultas con filtros, ordenamiento y paginación.
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await db.query('users')
  ///     .select('id, name')
  ///     .order('name')
  ///     .limit(10)
  ///     .execute();
  /// ```
  QueryBuilder query(String table, {String? schema});
}
