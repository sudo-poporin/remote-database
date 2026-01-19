import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/const/const.dart';
import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/filter_type.dart';
import 'package:remote_database/src/query/query_builder_base.dart';

/// Mixin que provee métodos de ejecución para QueryBuilder.
mixin ExecutionMixin on QueryBuilderBase {
  /// Ejecuta la consulta y retorna una lista de registros.
  ///
  /// Retorna [Right] con la lista de registros si la consulta es exitosa.
  /// Retorna [Left] con [RemoteDatabaseExceptions] si ocurre un error.
  ///
  /// Si no se encuentran registros, retorna [Right] con lista vacía.
  Future<Either<RemoteDatabaseExceptions, List<Map<String, dynamic>>>>
  execute() async {
    try {
      final result = await _buildQuery();
      return Right(result);
    } on PostgrestException catch (e) {
      if (e.code == ErrorCodes.noDataFound) {
        return const Right([]);
      }
      return Left(RemoteDatabaseExceptions.selectFailure(e));
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.selectFailure(e));
    }
  }

  /// Ejecuta la consulta y retorna un solo registro.
  ///
  /// Retorna [Right] con el registro si la consulta es exitosa.
  /// Retorna [Left] si ocurre un error o si hay más de un resultado.
  ///
  /// Si no se encuentra el registro, retorna [Right] con mapa vacío.
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await db.query('users')
  ///     .eq('id', 123)
  ///     .executeSingle();
  /// ```
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>>>
  executeSingle() async {
    try {
      final result = await _buildQuery().single();
      return Right(result);
    } on PostgrestException catch (e) {
      if (e.code == ErrorCodes.noDataFound) {
        return const Right({});
      }
      return Left(RemoteDatabaseExceptions.selectSingleFailure(e));
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.selectSingleFailure(e));
    }
  }

  /// Ejecuta la consulta y retorna un registro o null.
  ///
  /// Similar a [executeSingle] pero no falla si no hay resultados.
  /// Retorna `null` si no se encuentra ningún registro.
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await db.query('users')
  ///     .eq('email', 'test@example.com')
  ///     .executeMaybeSingle();
  ///
  /// result.fold(
  ///   (error) => print('Error: $error'),
  ///   (data) => data == null
  ///       ? print('No encontrado')
  ///       : print('Usuario: ${data['name']}'),
  /// );
  /// ```
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>?>>
  executeMaybeSingle() async {
    try {
      final result = await _buildQuery().maybeSingle();
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(RemoteDatabaseExceptions.selectSingleFailure(e));
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.selectSingleFailure(e));
    }
  }

  /// Ejecuta la consulta y retorna el conteo de registros.
  ///
  /// Útil para paginación o para verificar existencia sin traer datos.
  ///
  /// Nota: No aplica ordenamiento ni paginación (limit/range) ya que
  /// solo se necesita el conteo total de registros que coinciden con
  /// los filtros.
  ///
  /// Ejemplo:
  /// ```dart
  /// final result = await db.query('orders')
  ///     .eq('status', 'pending')
  ///     .executeCount();
  ///
  /// result.fold(
  ///   (error) => print('Error: $error'),
  ///   (count) => print('Órdenes pendientes: $count'),
  /// );
  /// ```
  Future<Either<RemoteDatabaseExceptions, int>> executeCount() async {
    try {
      // Construir query base
      var filterBuilder = client.schema(schema).from(table).select();

      // Aplicar filtros
      filterBuilder = _applyFilters(filterBuilder);

      // Ejecutar count
      final response = await filterBuilder.count(CountOption.exact);
      return Right(response.count);
    } on PostgrestException catch (e) {
      return Left(RemoteDatabaseExceptions.selectFailure(e));
    } on Exception catch (e) {
      return Left(RemoteDatabaseExceptions.selectFailure(e));
    }
  }

  /// Construye la query completa con filtros, ordenamiento y paginación.
  PostgrestTransformBuilder<List<Map<String, dynamic>>> _buildQuery() {
    // 1. Construir query base con select
    var filterBuilder = client.schema(schema).from(table).select(columns);

    // 2. Aplicar filtros
    filterBuilder = _applyFilters(filterBuilder);

    // 3. Aplicar ordenamiento y paginación
    PostgrestTransformBuilder<List<Map<String, dynamic>>> transformBuilder =
        filterBuilder;

    for (final order in orders) {
      transformBuilder = transformBuilder.order(
        order.column,
        ascending: order.ascending,
      );
    }

    if (limitCount != null) {
      transformBuilder = transformBuilder.limit(limitCount!);
    }

    if (rangeFrom != null && rangeTo != null) {
      transformBuilder = transformBuilder.range(rangeFrom!, rangeTo!);
    }

    return transformBuilder;
  }

  /// Aplica los filtros a la query.
  PostgrestFilterBuilder<List<Map<String, dynamic>>> _applyFilters(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
  ) {
    var result = query;
    for (final filter in filters) {
      result = _applyFilter(result, filter);
    }
    return result;
  }

  /// Aplica un filtro individual.
  PostgrestFilterBuilder<List<Map<String, dynamic>>> _applyFilter(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    FilterOperation filter,
  ) {
    switch (filter.type) {
      case FilterType.eq:
        return query.eq(filter.column, filter.value as Object);
      case FilterType.neq:
        return query.neq(filter.column, filter.value as Object);
      case FilterType.gt:
        return query.gt(filter.column, filter.value as Object);
      case FilterType.gte:
        return query.gte(filter.column, filter.value as Object);
      case FilterType.lt:
        return query.lt(filter.column, filter.value as Object);
      case FilterType.lte:
        return query.lte(filter.column, filter.value as Object);
      case FilterType.like:
        return query.like(filter.column, filter.value as String);
      case FilterType.ilike:
        return query.ilike(filter.column, filter.value as String);
      case FilterType.inList:
        return query.inFilter(filter.column, filter.value as List<Object>);
      case FilterType.not:
        final notData = filter.value as Map<String, dynamic>;
        return query.not(
          filter.column,
          notData['op'] as String,
          notData['value'] as Object,
        );
    }
  }
}
