import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/order_operation.dart';

/// Clase base abstracta para QueryBuilder.
///
/// Define los campos y métodos compartidos que los mixins necesitan.
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
}
