// Query builders require fluent API pattern which returns 'this'.
// ignore_for_file: avoid_returning_this

import 'package:remote_database/src/query/query_builder_base.dart';

/// Mixin que provee métodos de paginación para QueryBuilder.
mixin PaginationMixin on QueryBuilderBase {
  /// Limita el número de resultados retornados.
  ///
  /// Ejemplo:
  /// ```dart
  /// query.limit(10) // Retorna máximo 10 registros
  /// ```
  PaginationMixin limit(int count) {
    limitCount = count;
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
  PaginationMixin range(int from, int to) {
    rangeFrom = from;
    rangeTo = to;
    return this;
  }
}
