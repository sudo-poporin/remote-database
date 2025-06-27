import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/const/const.dart';

/// Repositorio de base de datos remota.
class RemoteDatabase extends _RemoteDatabaseImpl {
  /// Crea una instancia de [RemoteDatabase] con un cliente de Supabase.
  RemoteDatabase({required super.client});
}

/// Implentación de la interfaz [IRemoteDatabase].
class _RemoteDatabaseImpl implements IRemoteDatabase {
  /// Implementación de la base de datos remota.
  /// Crea una instancia de [RemoteDatabase] con un cliente de Supabase.
  _RemoteDatabaseImpl({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  @override
  Future<Either<RemoteDatabaseExceptions, List<Map<String, dynamic>>>>
  selectFrom({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
  }) async {
    try {
      final result = await _client
          .from(table)
          .select(columns)
          .match(data)
          .onError((error, stackTrace) {
            throw Exception(error);
          });

      return Right(result);
    } on Exception catch (e) {
      if (e is PostgrestException && e.code == ErrorCodes.noDataFound) {
        return const Left(RemoteDatabaseExceptions.noDataFound());
      }

      return Left(RemoteDatabaseExceptions.selectFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>>> selectSingle({
    required String table,
    required Map<String, Object> data,
    String columns = '*',
  }) async {
    try {
      final result = await _client
          .from(table)
          .select(columns)
          .match(data)
          .single()
          .onError((error, stackTrace) {
            throw Exception(error);
          });

      return Right(result);
    } on Exception catch (e) {
      if (e is PostgrestException && e.code == ErrorCodes.noDataFound) {
        return const Left(RemoteDatabaseExceptions.noDataFound());
      }

      return Left(RemoteDatabaseExceptions.selectSingleFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, void>> upsert({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
  }) async {
    try {
      await _client
          .from(table)
          .upsert(data, onConflict: onConflict)
          .onError((error, stackTrace) => throw Exception(error));

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
  }) async {
    try {
      final result = await _client
          .from(table)
          .insert(data)
          .select()
          .single()
          .onError((error, stackTrace) => throw Exception(error));

      return Right(result[resultIdColumn] as int);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.insertFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, int>> update({
    required String table,
    required Map<dynamic, dynamic> values,
    required Map<String, Object> where,
    String resultIdColumn = 'id',
  }) async {
    try {
      final result = await _client
          .from(table)
          .update(values)
          .match(where)
          .select()
          .single()
          .onError((error, stackTrace) => throw Exception(error));

      return Right(result[resultIdColumn] as int);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.updateFailure(e));
    }
  }

  @override
  Future<Either<RemoteDatabaseExceptions, void>> delete({
    required String table,
    required Map<String, Object> where,
  }) async {
    try {
      await _client
          .from(table)
          .delete()
          .match(where)
          .onError((error, stackTrace) => throw Exception(error));

      return const Right(null);
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.deleteFailure(e));
    }
  }
}
