// Query builders require fluent API pattern which returns 'this'.
// ignore_for_file: avoid_returning_this

import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/filter_type.dart';
import 'package:remote_database/src/query/query_builder_base.dart';

/// Mixin que provee métodos de filtrado para QueryBuilder.
mixin FilterMixin on QueryBuilderBase {
  /// Filtra por igualdad (=).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.eq('status', 'active')
  /// ```
  FilterMixin eq(String column, Object value) {
    filters.add(
      FilterOperation(type: FilterType.eq, column: column, value: value),
    );
    return this;
  }

  /// Filtra por desigualdad (!=).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.neq('status', 'deleted')
  /// ```
  FilterMixin neq(String column, Object value) {
    filters.add(
      FilterOperation(type: FilterType.neq, column: column, value: value),
    );
    return this;
  }

  /// Filtra por mayor que (>).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.gt('price', 100)
  /// ```
  FilterMixin gt(String column, Object value) {
    filters.add(
      FilterOperation(type: FilterType.gt, column: column, value: value),
    );
    return this;
  }

  /// Filtra por mayor o igual que (>=).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.gte('date', '2024-01-01')
  /// ```
  FilterMixin gte(String column, Object value) {
    filters.add(
      FilterOperation(type: FilterType.gte, column: column, value: value),
    );
    return this;
  }

  /// Filtra por menor que (<).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.lt('stock', 10)
  /// ```
  FilterMixin lt(String column, Object value) {
    filters.add(
      FilterOperation(type: FilterType.lt, column: column, value: value),
    );
    return this;
  }

  /// Filtra por menor o igual que (<=).
  ///
  /// Ejemplo:
  /// ```dart
  /// query.lte('date', '2024-12-31')
  /// ```
  FilterMixin lte(String column, Object value) {
    filters.add(
      FilterOperation(type: FilterType.lte, column: column, value: value),
    );
    return this;
  }

  /// Filtra por patrón case-sensitive (LIKE).
  ///
  /// Usa `%` como wildcard para cualquier secuencia de caracteres.
  /// Usa `_` como wildcard para un solo carácter.
  ///
  /// Ejemplo:
  /// ```dart
  /// query.like('name', 'John%')  // Nombres que empiezan con "John"
  /// query.like('code', 'A_B')    // Códigos como "A1B", "A2B", etc.
  /// ```
  FilterMixin like(String column, String pattern) {
    filters.add(
      FilterOperation(type: FilterType.like, column: column, value: pattern),
    );
    return this;
  }

  /// Filtra por patrón case-insensitive (ILIKE).
  ///
  /// Usa `%` como wildcard para cualquier secuencia de caracteres.
  /// Usa `_` como wildcard para un solo carácter.
  ///
  /// Ejemplo:
  /// ```dart
  /// query.ilike('name', '%john%')  // Busca "john" sin importar mayúsculas
  /// ```
  FilterMixin ilike(String column, String pattern) {
    filters.add(
      FilterOperation(type: FilterType.ilike, column: column, value: pattern),
    );
    return this;
  }

  /// Filtra por lista de valores (IN clause).
  ///
  /// Retorna registros donde la columna coincide con cualquier valor
  /// de la lista.
  ///
  /// Ejemplo:
  /// ```dart
  /// query.inFilter('status', ['pending', 'processing'])
  /// query.inFilter('category_id', [1, 2, 3])
  /// ```
  FilterMixin inFilter(String column, List<Object> values) {
    filters.add(
      FilterOperation(type: FilterType.inList, column: column, value: values),
    );
    return this;
  }

  /// Aplica negación a un operador.
  ///
  /// [column] es la columna a filtrar.
  /// [operator] es el operador a negar ('eq', 'like', 'ilike', 'in', etc.).
  /// [value] es el valor a comparar.
  ///
  /// Ejemplo:
  /// ```dart
  /// query.not('status', 'eq', 'deleted')     // status != 'deleted'
  /// query.not('name', 'ilike', '%test%')     // name NOT ILIKE '%test%'
  /// query.not('id', 'in', '(1,2,3)')         // id NOT IN (1,2,3)
  /// ```
  FilterMixin not(String column, String operator, Object value) {
    filters.add(
      FilterOperation(
        type: FilterType.not,
        column: column,
        value: {'op': operator, 'value': value},
      ),
    );
    return this;
  }
}
