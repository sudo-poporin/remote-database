// coverage:ignore-file
// Wrapper sobre la cadena de Supabase (`schema().from().select()…`) — chain
// types (`PostgrestFilterBuilder`, etc.) no son razonablemente mockeables.

import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/const/const.dart';

/// Repositorio de base de datos remota.
class RemoteDatabaseBase extends _RemoteDatabase {
  /// Crea una instancia de [RemoteDatabaseBase] con un cliente de Supabase.
  RemoteDatabaseBase({required super.client});
}

/// Implementación de la interfaz [IRemoteDatabase].
class _RemoteDatabase implements IRemoteDatabase {
  _RemoteDatabase({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  @override
  Future<Either<RemoteDatabaseExceptions, List<Map<String, dynamic>>>>
  selectFrom({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
    String? schema,
  }) async {
    try {
      final result = await _client
          .schema(schema ?? 'public')
          .from(table)
          .select(columns)
          .match(data);

      return Right(result);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.selectFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>>> selectSingle({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
    String? schema,
  }) async {
    try {
      final result = await _client
          .schema(schema ?? 'public')
          .from(table)
          .select(columns)
          .match(data)
          .single()
          .onError((error, stackTrace) {
            if (error is PostgrestException &&
                error.code == ErrorCodes.noDataFound) {
              throw const RemoteDatabaseExceptions.noDataFound();
            }
            throw Exception(error);
          });

      return Right(result);
    } on Exception catch (e) {
      return e is RemoteDatabaseNoDataFound
          ? const Right({})
          : Left(RemoteDatabaseExceptions.selectSingleFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, void>> upsert({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
    String? schema,
  }) async {
    try {
      await _client
          .schema(schema ?? 'public')
          .from(table)
          .upsert(data, onConflict: onConflict);

      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.upsertFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, int>> upsertReturning({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
    String resultIdColumn = 'id',
    String? schema,
  }) async {
    try {
      final result = await _client
          .schema(schema ?? 'public')
          .from(table)
          .upsert(data, onConflict: onConflict)
          .select();

      // `.select()` y no `.single()`: `single()` tira `PostgrestException`
      // cuando no hay exactamente una fila, y `.first` sobre una lista vacia
      // tira `StateError`, que es un `Error` y se escaparia del
      // `on Exception catch`. Con la lista a la vista el caso vacio se contesta
      // como `Left`, que es lo que el llamador sabe manejar.
      if (result.isEmpty) {
        return Left(
          RemoteDatabaseExceptions.upsertFailure(
            Exception('El upsert no devolvio ninguna fila'),
          ),
        );
      }

      return Right(result.first[resultIdColumn] as int);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.upsertFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, int>> insert({
    required String table,
    required Map<String, dynamic> data,
    String resultIdColumn = 'id',
    String? schema,
  }) async {
    try {
      final result = await _client
          .schema(schema ?? 'public')
          .from(table)
          .insert(data)
          .select()
          .single();

      return Right(result[resultIdColumn] as int);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.insertFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, int?>> insertIfAbsent({
    required String table,
    required Map<String, dynamic> data,
    required String onConflict,
    String resultIdColumn = 'id',
    String? schema,
  }) async {
    try {
      // `ignoreDuplicates: true` es el `ON CONFLICT DO NOTHING` de PostgREST.
      // El `select()` devuelve la lista vacia cuando el conflicto ya estaba, y
      // por eso el retorno es nullable: no hay fila que reportar porque esta
      // llamada no escribio ninguna.
      final result = await _client
          .schema(schema ?? 'public')
          .from(table)
          .upsert(data, onConflict: onConflict, ignoreDuplicates: true)
          .select();

      if (result.isEmpty) return const Right(null);

      return Right(result.first[resultIdColumn] as int);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.insertFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, int>> update({
    required String table,
    required Map<String, dynamic> values,
    required Map<String, Object> where,
    String resultIdColumn = 'id',
    String? schema,
  }) async {
    try {
      final result = await _client
          .schema(schema ?? 'public')
          .from(table)
          .update(values)
          .match(where)
          .select()
          .single();

      return Right(result[resultIdColumn] as int);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.updateFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, void>> delete({
    required String table,
    required Map<String, Object> where,
    String? schema,
  }) async {
    try {
      await _client
          .schema(schema ?? 'public')
          .from(table)
          .delete()
          .match(where);

      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.deleteFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, void>> deleteWhereIn({
    required String table,
    required String column,
    required List<Object> values,
    required Map<String, Object> where,
    String? schema,
  }) async {
    // Las dos guardas van antes del try y antes de tocar el cliente. Ninguna
    // de las dos listas vacías es un no-op inofensivo: `values` vacío deja el
    // borrado sin acotar, y `where` vacío lo deja sin dueño, o sea cruzando
    // entre usuarios si alguna policy de RLS no está bien cerrada.
    if (values.isEmpty) {
      return const Left(
        RemoteDatabaseExceptions.deleteFailure(
          'deleteWhereIn requiere al menos un valor en `values`.',
        ),
      );
    }

    if (where.isEmpty) {
      return const Left(
        RemoteDatabaseExceptions.deleteFailure(
          'deleteWhereIn requiere al menos una condición en `where`.',
        ),
      );
    }

    try {
      await _client
          .schema(schema ?? 'public')
          .from(table)
          .delete()
          .inFilter(column, values)
          .match(where);

      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.deleteFailure(e));
    }
  }

  @override
  QueryBuilder query(String table, {String? schema}) {
    return QueryBuilder(
      client: _client,
      table: table,
      schema: schema,
    );
  }
}
