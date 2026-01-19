import 'package:remote_database/src/query/filter_type.dart';

/// Representa una operación de filtro para el QueryBuilder.
class FilterOperation {
  /// Crea una operación de filtro.
  const FilterOperation({
    required this.type,
    required this.column,
    required this.value,
  });

  /// Tipo de filtro a aplicar.
  final FilterType type;

  /// Nombre de la columna a filtrar.
  final String column;

  /// Valor a comparar.
  final dynamic value;
}
