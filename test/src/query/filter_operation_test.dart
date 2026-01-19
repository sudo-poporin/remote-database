import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/src/query/filter_operation.dart';
import 'package:remote_database/src/query/filter_type.dart';

void main() {
  group('FilterOperation', () {
    test('se crea con todos los parámetros', () {
      const operation = FilterOperation(
        type: FilterType.eq,
        column: 'status',
        value: 'active',
      );

      expect(operation.type, equals(FilterType.eq));
      expect(operation.column, equals('status'));
      expect(operation.value, equals('active'));
    });

    test('soporta valor String', () {
      const operation = FilterOperation(
        type: FilterType.like,
        column: 'name',
        value: 'John%',
      );

      expect(operation.value, isA<String>());
      expect(operation.value, equals('John%'));
    });

    test('soporta valor int', () {
      const operation = FilterOperation(
        type: FilterType.gt,
        column: 'price',
        value: 100,
      );

      expect(operation.value, isA<int>());
      expect(operation.value, equals(100));
    });

    test('soporta valor double', () {
      const operation = FilterOperation(
        type: FilterType.lte,
        column: 'rating',
        value: 4.5,
      );

      expect(operation.value, isA<double>());
      expect(operation.value, equals(4.5));
    });

    test('soporta valor bool', () {
      const operation = FilterOperation(
        type: FilterType.eq,
        column: 'active',
        value: true,
      );

      expect(operation.value, isA<bool>());
      expect(operation.value, isTrue);
    });

    test('soporta valor List para inList', () {
      const operation = FilterOperation(
        type: FilterType.inList,
        column: 'status',
        value: ['pending', 'processing'],
      );

      expect(operation.value, isA<List<String>>());
      expect(operation.value, equals(['pending', 'processing']));
    });

    test('soporta valor Map para not', () {
      const operation = FilterOperation(
        type: FilterType.not,
        column: 'status',
        value: {'op': 'eq', 'value': 'deleted'},
      );

      expect(operation.value, isA<Map<String, Object>>());
      final value = operation.value as Map<String, dynamic>;
      expect(value['op'], equals('eq'));
      expect(value['value'], equals('deleted'));
    });
  });

  group('FilterType', () {
    test('contiene todos los tipos esperados', () {
      expect(FilterType.values, hasLength(10));
      expect(FilterType.values, contains(FilterType.eq));
      expect(FilterType.values, contains(FilterType.neq));
      expect(FilterType.values, contains(FilterType.gt));
      expect(FilterType.values, contains(FilterType.gte));
      expect(FilterType.values, contains(FilterType.lt));
      expect(FilterType.values, contains(FilterType.lte));
      expect(FilterType.values, contains(FilterType.like));
      expect(FilterType.values, contains(FilterType.ilike));
      expect(FilterType.values, contains(FilterType.inList));
      expect(FilterType.values, contains(FilterType.not));
    });

    test('eq tiene índice 0', () {
      expect(FilterType.eq.index, equals(0));
    });

    test('not tiene índice 9', () {
      expect(FilterType.not.index, equals(9));
    });
  });
}
