// Query builders require fluent API pattern which returns 'this'.
// ignore_for_file: avoid_returning_this

import 'package:remote_database/src/query/order_operation.dart';
import 'package:remote_database/src/query/query_builder_base.dart';

/// Mixin que provee métodos de ordenamiento para QueryBuilder.
mixin OrderingMixin on QueryBuilderBase {
  /// Ordena los resultados por una columna.
  ///
  /// [column] es el nombre de la columna por la cual ordenar.
  /// [ascending] define si el orden es ascendente (default) o descendente.
  ///
  /// Se pueden encadenar múltiples ordenamientos:
  /// ```dart
  /// query.order('category').order('name', ascending: false)
  /// ```
  OrderingMixin order(String column, {bool ascending = true}) {
    orders.add(OrderOperation(column: column, ascending: ascending));
    return this;
  }
}
