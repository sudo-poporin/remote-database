// Query builders require fluent API pattern which returns 'this'.
// This is the standard pattern used by Supabase SDK and other query builders.
// ignore_for_file: avoid_returning_this

import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/const/const.dart';
import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/filter_type.dart';
import 'package:remote_database/src/query/order_operation.dart';

/// Query builder para consultas avanzadas a la base de datos.
///
/// Permite construir consultas de forma fluida con soporte para:
/// - Selección de columnas
/// - Ordenamiento (ascendente/descendente)
/// - Paginación (limit/range)
///
/// Ejemplo de uso:
/// ```dart
/// final result = await db.query('users')
///     .select('id, name, email')
///     .order('name')
///     .limit(10)
///     .execute();
/// ```
class QueryBuilder {
  /// Crea un QueryBuilder para la tabla especificada.
  QueryBuilder({
    required SupabaseClient client,
    required String table,
    String? schema,
  })  : _client = client,
        _table = table,
        _schema = schema ?? 'public';

  final SupabaseClient _client;
  final String _table;
  final String _schema;

  String _columns = '*';
  final List<FilterOperation> _filters = [];
  final List<OrderOperation> _orders = [];
  int? _limitCount;
  int? _rangeFrom;
  int? _rangeTo;

  /// Selecciona columnas específicas.
  ///
  /// Por defecto selecciona todas las columnas ('*').
  ///
  /// Ejemplo:
  /// ```dart
  /// query.select('id, name, email')
  /// ```
  QueryBuilder select(String columns) {
    _columns = columns;
    return this;
  }

  /// Ordena los resultados por una columna.
  ///
  /// [column] es el nombre de la columna por la cual ordenar.
  /// [ascending] define si el orden es ascendente (default) o descendente.
  ///
  /// Se pueden encadenar múltiples ordenamientos:
  /// ```dart
  /// query.order('category').order('name', ascending: false)
  /// ```
  QueryBuilder order(String column, {bool ascending = true}) {
    _orders.add(OrderOperation(column: column, ascending: ascending));
    return this;
  }

  /// Limita el número de resultados retornados.
  ///
  /// Ejemplo:
  /// ```dart
  /// query.limit(10) // Retorna máximo 10 registros
  /// ```
  QueryBuilder limit(int count) {
    _limitCount = count;
    return this;
  }

  /// Define un rango de resultados para paginación.
  ///
  /// [from] es el índice inicial (inclusivo, base 0).
  /// [to] es el índice final (inclusivo).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.range(0, 9)   // Primeros 10 registros
  /// query.range(10, 19) // Siguientes 10 registros
  /// ```
  QueryBuilder range(int from, int to) {
    _rangeFrom = from;
    _rangeTo = to;
    return this;
  }

  /// Ejecuta la consulta y retorna una lista de registros.
  ///
  /// Retorna [Right] con la lista de registros si la consulta es exitosa.
  /// Retorna [Left] con [RemoteDatabaseExceptions] si ocurre un error.
  ///
  /// Si no se encuentran registros, retorna [Right] con lista vacía.
  Future<Either<RemoteDatabaseExceptions, List<Map<String, dynamic>>>>
      execute() async {
    try {
      final result = await _buildAndExecuteQuery();
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

  /// Construye y ejecuta la query completa.
  Future<List<Map<String, dynamic>>> _buildAndExecuteQuery() {
    // 1. Construir query base con select
    var filterBuilder = _client.schema(_schema).from(_table).select(_columns);

    // 2. Aplicar filtros
    filterBuilder = _applyFilters(filterBuilder);

    // 3. Aplicar ordenamiento y paginación
    PostgrestTransformBuilder<List<Map<String, dynamic>>> transformBuilder =
        filterBuilder;

    for (final order in _orders) {
      transformBuilder =
          transformBuilder.order(order.column, ascending: order.ascending);
    }

    if (_limitCount != null) {
      transformBuilder = transformBuilder.limit(_limitCount!);
    }

    if (_rangeFrom != null && _rangeTo != null) {
      transformBuilder = transformBuilder.range(_rangeFrom!, _rangeTo!);
    }

    return transformBuilder;
  }

  /// Aplica los filtros a la query.
  PostgrestFilterBuilder<List<Map<String, dynamic>>> _applyFilters(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
  ) {
    var result = query;
    for (final filter in _filters) {
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
