import 'package:fpdart/fpdart.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/order_operation.dart';

/// Clase base abstracta para QueryBuilder.
///
/// Define los campos y métodos compartidos que los mixins necesitan.
/// Los métodos de encadenamiento están declarados aquí para permitir
/// el fluent API pattern con tipos correctos.
abstract class QueryBuilderBase {
  /// Cliente de Supabase.
  SupabaseClient get client;

  /// Nombre de la tabla.
  String get table;

  /// Schema de la base de datos.
  String get schema;

  /// Columnas a seleccionar.
  String get columns;

  /// Establece las columnas a seleccionar.
  set columns(String value);

  /// Lista de filtros a aplicar.
  List<FilterOperation> get filters;

  /// Lista de ordenamientos a aplicar.
  List<OrderOperation> get orders;

  /// Límite de resultados.
  int? get limitCount;

  /// Establece el límite de resultados.
  set limitCount(int? value);

  /// Rango inicial para paginación.
  int? get rangeFrom;

  /// Establece el rango inicial.
  set rangeFrom(int? value);

  /// Rango final para paginación.
  int? get rangeTo;

  /// Establece el rango final.
  set rangeTo(int? value);

  // ===========================================================================
  // Métodos de FilterMixin
  // ===========================================================================

  /// Filtra por igualdad (=).
  QueryBuilderBase eq(String column, Object value);

  /// Filtra por desigualdad (!=).
  QueryBuilderBase neq(String column, Object value);

  /// Filtra por mayor que (>).
  QueryBuilderBase gt(String column, Object value);

  /// Filtra por mayor o igual que (>=).
  QueryBuilderBase gte(String column, Object value);

  /// Filtra por menor que (<).
  QueryBuilderBase lt(String column, Object value);

  /// Filtra por menor o igual que (<=).
  QueryBuilderBase lte(String column, Object value);

  /// Filtra por patrón case-sensitive (LIKE).
  QueryBuilderBase like(String column, String pattern);

  /// Filtra por patrón case-insensitive (ILIKE).
  QueryBuilderBase ilike(String column, String pattern);

  /// Filtra por lista de valores (IN clause).
  QueryBuilderBase inFilter(String column, List<Object> values);

  /// Aplica negación a un operador.
  QueryBuilderBase not(String column, String operator, Object value);

  // ===========================================================================
  // Métodos de OrderingMixin
  // ===========================================================================

  /// Ordena los resultados por una columna.
  QueryBuilderBase order(String column, {bool ascending = true});

  // ===========================================================================
  // Métodos de PaginationMixin
  // ===========================================================================

  /// Limita el número de resultados retornados.
  QueryBuilderBase limit(int count);

  /// Define un rango de resultados para paginación.
  QueryBuilderBase range(int from, int to);

  // ===========================================================================
  // Métodos de ExecutionMixin
  // ===========================================================================

  /// Ejecuta la consulta y retorna una lista de resultados.
  Future<Either<RemoteDatabaseExceptions, List<Map<String, dynamic>>>>
      execute();

  /// Ejecuta la consulta y retorna un solo resultado.
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>>>
      executeSingle();

  /// Ejecuta la consulta y retorna un resultado opcional.
  Future<Either<RemoteDatabaseExceptions, Map<String, dynamic>?>>
      executeMaybeSingle();

  /// Ejecuta la consulta y retorna el conteo de resultados.
  Future<Either<RemoteDatabaseExceptions, int>> executeCount();
}
