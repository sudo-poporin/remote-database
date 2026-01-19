// Query builders require fluent API pattern which returns 'this'.
// ignore_for_file: avoid_returning_this

import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/mixins/execution_mixin.dart';
import 'package:remote_database/src/query/mixins/filter_mixin.dart';
import 'package:remote_database/src/query/mixins/ordering_mixin.dart';
import 'package:remote_database/src/query/mixins/pagination_mixin.dart';
import 'package:remote_database/src/query/order_operation.dart';
import 'package:remote_database/src/query/query_builder_base.dart';

/// Query builder para consultas avanzadas a la base de datos.
///
/// Permite construir consultas de forma fluida con soporte para:
/// - Selección de columnas
/// - Filtros avanzados (eq, neq, gt, gte, lt, lte, like, ilike, inFilter, not)
/// - Ordenamiento (ascendente/descendente)
/// - Paginación (limit/range)
///
/// Ejemplo de uso:
/// ```dart
/// final result = await db.query('users')
///     .select('id, name, email')
///     .eq('active', true)
///     .order('name')
///     .limit(10)
///     .execute();
/// ```
class QueryBuilder extends QueryBuilderBase
    with FilterMixin, PaginationMixin, OrderingMixin, ExecutionMixin {
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

  // ===========================================================================
  // Implementación de QueryBuilderBase
  // ===========================================================================

  @override
  SupabaseClient get client => _client;

  @override
  String get table => _table;

  @override
  String get schema => _schema;

  @override
  String get columns => _columns;

  @override
  set columns(String value) => _columns = value;

  @override
  List<FilterOperation> get filters => _filters;

  @override
  List<OrderOperation> get orders => _orders;

  @override
  int? get limitCount => _limitCount;

  @override
  set limitCount(int? value) => _limitCount = value;

  @override
  int? get rangeFrom => _rangeFrom;

  @override
  set rangeFrom(int? value) => _rangeFrom = value;

  @override
  int? get rangeTo => _rangeTo;

  @override
  set rangeTo(int? value) => _rangeTo = value;

  // ===========================================================================
  // Métodos propios de QueryBuilder
  // ===========================================================================

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
}
