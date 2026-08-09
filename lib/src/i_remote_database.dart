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

  /// Inserta un registro y no falla si la fila ya existe.
  ///
  /// Devuelve el id del registro insertado, o `null` si ya estaba: ese `null`
  /// es la respuesta a "no lo inserte yo", no un error.
  ///
  /// Es la version atomica de "insertar si no esta". Consultar primero y
  /// escribir despues deja una ventana entre las dos llamadas por la que cabe
  /// otra escritura concurrente; aca la decision la toma la base en una sola
  /// sentencia.
  ///
  /// [onConflict] son las columnas del indice unico que define el conflicto,
  /// separadas por coma. **Tiene que existir un indice unico sobre esas
  /// columnas**: sin el, la base no tiene contra que detectar el conflicto y la
  /// insercion se comporta como una normal.
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await db.insertIfAbsent(
  ///   table: 'game_user',
  ///   data: {'user_id': userId, 'game_id': gameId},
  ///   onConflict: 'user_id,game_id',
  /// );
  /// ```
  Future<Either<RemoteDatabaseExceptions, int?>> insertIfAbsent({
    required String table,
    required Map<String, dynamic> data,
    required String onConflict,
    String resultIdColumn = 'id',
    String? schema,
  });

  /// Actualiza un registro en la base de datos.
  Future<Either<RemoteDatabaseExceptions, int>> update({
    required String table,
    required Map<String, dynamic> values,
    required Map<String, Object> where,
    String resultIdColumn = 'id',
    String? schema,
  });

  /// Elimina un registro en la base de datos.
  Future<Either<RemoteDatabaseExceptions, void>> delete({
    required String table,
    required Map<String, Object> where,
    String? schema,
  });

  /// Elimina los registros cuya columna [column] está en [values].
  ///
  /// [delete] resuelve su `where` con `.match(...)`, que solo admite igualdad,
  /// así que borrar N registros identificados por su id cuesta N llamadas.
  /// Este método los borra en una sola, traduciendo [column] y [values] a un
  /// filtro `IN`.
  ///
  /// [where] se combina con el `IN` como condiciones de igualdad adicionales,
  /// igual que en [delete].
  ///
  /// **Los dos mapas son obligatorios y no pueden venir vacíos.** Cualquiera de
  /// los dos vacío devuelve `Left(deleteFailure)` **sin emitir el request**, y
  /// cada uno acota una cosa distinta:
  ///
  /// - Un [values] vacío dejaría el borrado **sin acotar**: un `IN ()` sin
  ///   valores afecta a toda la tabla dentro de lo que permita RLS.
  /// - Un [where] vacío dejaría el borrado **sin dueño**: `IN` acota *qué*
  ///   filas, no *de quién*, así que sin condiciones de pertenencia el borrado
  ///   cruza entre usuarios. La consecuencia de una policy de RLS mal cerrada
  ///   no debería ser el borrado de datos ajenos, así que la condición se exige
  ///   también del lado del cliente.
  ///
  /// El precio de exigir [where] es que borrar filas por su propia clave
  /// primaria —donde el `IN` ya acota del todo y no hay nada más que
  /// filtrar— no tiene camino por acá: usar [delete] por valor.
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await db.deleteWhereIn(
  ///   table: 'order_item',
  ///   column: 'order_id',
  ///   values: [12, 34, 56],
  ///   where: {'user_id': userId},
  /// );
  /// ```
  Future<Either<RemoteDatabaseExceptions, void>> deleteWhereIn({
    required String table,
    required String column,
    required List<Object> values,
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
