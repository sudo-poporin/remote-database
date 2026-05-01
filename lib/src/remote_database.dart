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
  QueryBuilder query(String table, {String? schema}) {
    return QueryBuilder(
      client: _client,
      table: table,
      schema: schema,
    );
  }
}
