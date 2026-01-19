import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/src/query/order_operation.dart';

void main() {
  group('OrderOperation', () {
    test('se crea con ordenamiento ascendente', () {
      const operation = OrderOperation(
        column: 'name',
        ascending: true,
      );

      expect(operation.column, equals('name'));
      expect(operation.ascending, isTrue);
    });

    test('se crea con ordenamiento descendente', () {
      const operation = OrderOperation(
        column: 'created_at',
        ascending: false,
      );

      expect(operation.column, equals('created_at'));
      expect(operation.ascending, isFalse);
    });

    test('almacena nombre de columna correctamente', () {
      const operation = OrderOperation(
        column: 'user_profile.last_login',
        ascending: true,
      );

      expect(operation.column, equals('user_profile.last_login'));
    });
  });
}
