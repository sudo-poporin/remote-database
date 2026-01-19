/// Representa una operación de ordenamiento para el QueryBuilder.
class OrderOperation {
  /// Crea una operación de ordenamiento.
  const OrderOperation({
    required this.column,
    required this.ascending,
  });

  /// Nombre de la columna por la cual ordenar.
  final String column;

  /// Si es true, ordena ascendente (ASC). Si es false, descendente (DESC).
  final bool ascending;
}
