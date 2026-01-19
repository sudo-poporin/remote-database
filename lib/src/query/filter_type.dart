/// Tipos de filtro soportados por el QueryBuilder.
enum FilterType {
  /// Igualdad (=).
  eq,

  /// No igual (!=).
  neq,

  /// Mayor que (>).
  gt,

  /// Mayor o igual que (>=).
  gte,

  /// Menor que (<).
  lt,

  /// Menor o igual que (<=).
  lte,

  /// Búsqueda de patrón case-sensitive (LIKE).
  like,

  /// Búsqueda de patrón case-insensitive (ILIKE).
  ilike,

  /// Lista de valores (IN).
  inList,

  /// Negación genérica (NOT).
  not,
}
