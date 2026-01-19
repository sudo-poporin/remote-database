import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/remote_database.dart';
import 'package:remote_database/src/query/filter_type.dart';

import '../../dependencies/mock_runner_test.mocks.dart';

void main() {
  late MockSupabaseClient mockClient;
  late QueryBuilder queryBuilder;

  setUp(() {
    mockClient = MockSupabaseClient();
    queryBuilder = QueryBuilder(
      client: mockClient,
      table: 'test_table',
    );
  });

  group('QueryBuilder - Inicialización', () {
    test('se crea con valores por defecto correctos', () {
      expect(queryBuilder.table, equals('test_table'));
      expect(queryBuilder.schema, equals('public'));
      expect(queryBuilder.columns, equals('*'));
      expect(queryBuilder.filters, isEmpty);
      expect(queryBuilder.orders, isEmpty);
      expect(queryBuilder.limitCount, isNull);
      expect(queryBuilder.rangeFrom, isNull);
      expect(queryBuilder.rangeTo, isNull);
    });

    test('se crea con schema personalizado', () {
      final builder = QueryBuilder(
        client: mockClient,
        table: 'products',
        schema: 'ecommerce',
      );

      expect(builder.schema, equals('ecommerce'));
    });
  });

  group('QueryBuilder - select()', () {
    test('modifica las columnas a seleccionar', () {
      queryBuilder.select('id, name, email');

      expect(queryBuilder.columns, equals('id, name, email'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.select('id');

      expect(result, same(queryBuilder));
    });

    test('sobreescribe columnas anteriores', () {
      queryBuilder
        ..select('id, name')
        ..select('email, phone');

      expect(queryBuilder.columns, equals('email, phone'));
    });
  });

  group('QueryBuilder - order()', () {
    test('agrega ordenamiento ascendente por defecto', () {
      queryBuilder.order('name');

      expect(queryBuilder.orders, hasLength(1));
      expect(queryBuilder.orders.first.column, equals('name'));
      expect(queryBuilder.orders.first.ascending, isTrue);
    });

    test('agrega ordenamiento descendente', () {
      queryBuilder.order('created_at', ascending: false);

      expect(queryBuilder.orders, hasLength(1));
      expect(queryBuilder.orders.first.column, equals('created_at'));
      expect(queryBuilder.orders.first.ascending, isFalse);
    });

    test('permite múltiples ordenamientos', () {
      queryBuilder
        ..order('category')
        ..order('name', ascending: false);

      expect(queryBuilder.orders, hasLength(2));
      expect(queryBuilder.orders[0].column, equals('category'));
      expect(queryBuilder.orders[0].ascending, isTrue);
      expect(queryBuilder.orders[1].column, equals('name'));
      expect(queryBuilder.orders[1].ascending, isFalse);
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.order('id');

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - limit()', () {
    test('establece límite de resultados', () {
      queryBuilder.limit(10);

      expect(queryBuilder.limitCount, equals(10));
    });

    test('sobreescribe límite anterior', () {
      queryBuilder
        ..limit(10)
        ..limit(20);

      expect(queryBuilder.limitCount, equals(20));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.limit(5);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - range()', () {
    test('establece rango de paginación', () {
      queryBuilder.range(0, 9);

      expect(queryBuilder.rangeFrom, equals(0));
      expect(queryBuilder.rangeTo, equals(9));
    });

    test('sobreescribe rango anterior', () {
      queryBuilder
        ..range(0, 9)
        ..range(10, 19);

      expect(queryBuilder.rangeFrom, equals(10));
      expect(queryBuilder.rangeTo, equals(19));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.range(0, 9);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - Encadenamiento fluido', () {
    test('permite encadenar múltiples métodos con cascade', () {
      queryBuilder
        ..select('id, name, price')
        ..order('price', ascending: false)
        ..limit(10)
        ..range(0, 9);

      expect(queryBuilder.columns, equals('id, name, price'));
      expect(queryBuilder.orders, hasLength(1));
      expect(queryBuilder.limitCount, equals(10));
      expect(queryBuilder.rangeFrom, equals(0));
      expect(queryBuilder.rangeTo, equals(9));
    });
  });

  group('QueryBuilder - eq()', () {
    test('agrega filtro de igualdad', () {
      queryBuilder.eq('status', 'active');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.eq));
      expect(queryBuilder.filters.first.column, equals('status'));
      expect(queryBuilder.filters.first.value, equals('active'));
    });

    test('soporta diferentes tipos de valores', () {
      queryBuilder
        ..eq('name', 'John')
        ..eq('age', 30)
        ..eq('active', true);

      expect(queryBuilder.filters, hasLength(3));
      expect(queryBuilder.filters[0].value, equals('John'));
      expect(queryBuilder.filters[1].value, equals(30));
      expect(queryBuilder.filters[2].value, equals(true));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.eq('id', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - neq()', () {
    test('agrega filtro de desigualdad', () {
      queryBuilder.neq('status', 'deleted');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.neq));
      expect(queryBuilder.filters.first.column, equals('status'));
      expect(queryBuilder.filters.first.value, equals('deleted'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.neq('id', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - gt()', () {
    test('agrega filtro mayor que', () {
      queryBuilder.gt('price', 100);

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.gt));
      expect(queryBuilder.filters.first.column, equals('price'));
      expect(queryBuilder.filters.first.value, equals(100));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.gt('id', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - gte()', () {
    test('agrega filtro mayor o igual que', () {
      queryBuilder.gte('date', '2024-01-01');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.gte));
      expect(queryBuilder.filters.first.column, equals('date'));
      expect(queryBuilder.filters.first.value, equals('2024-01-01'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.gte('id', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - lt()', () {
    test('agrega filtro menor que', () {
      queryBuilder.lt('stock', 10);

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.lt));
      expect(queryBuilder.filters.first.column, equals('stock'));
      expect(queryBuilder.filters.first.value, equals(10));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.lt('id', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - lte()', () {
    test('agrega filtro menor o igual que', () {
      queryBuilder.lte('date', '2024-12-31');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.lte));
      expect(queryBuilder.filters.first.column, equals('date'));
      expect(queryBuilder.filters.first.value, equals('2024-12-31'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.lte('id', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - like()', () {
    test('agrega filtro de patrón case-sensitive', () {
      queryBuilder.like('name', 'John%');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.like));
      expect(queryBuilder.filters.first.column, equals('name'));
      expect(queryBuilder.filters.first.value, equals('John%'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.like('name', '%test%');

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - ilike()', () {
    test('agrega filtro de patrón case-insensitive', () {
      queryBuilder.ilike('name', '%john%');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.ilike));
      expect(queryBuilder.filters.first.column, equals('name'));
      expect(queryBuilder.filters.first.value, equals('%john%'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.ilike('name', '%test%');

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - inFilter()', () {
    test('agrega filtro IN clause', () {
      queryBuilder.inFilter('status', ['pending', 'processing']);

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.inList));
      expect(queryBuilder.filters.first.column, equals('status'));
      expect(
        queryBuilder.filters.first.value,
        equals(['pending', 'processing']),
      );
    });

    test('soporta lista de números', () {
      queryBuilder.inFilter('category_id', [1, 2, 3]);

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.value, equals([1, 2, 3]));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.inFilter('id', [1, 2]);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - not()', () {
    test('agrega filtro de negación', () {
      queryBuilder.not('status', 'eq', 'deleted');

      expect(queryBuilder.filters, hasLength(1));
      expect(queryBuilder.filters.first.type, equals(FilterType.not));
      expect(queryBuilder.filters.first.column, equals('status'));

      final value = queryBuilder.filters.first.value as Map<String, dynamic>;
      expect(value['op'], equals('eq'));
      expect(value['value'], equals('deleted'));
    });

    test('soporta diferentes operadores', () {
      queryBuilder
        ..not('name', 'ilike', '%test%')
        ..not('id', 'in', '(1,2,3)');

      expect(queryBuilder.filters, hasLength(2));

      final filter1 = queryBuilder.filters[0].value as Map<String, dynamic>;
      expect(filter1['op'], equals('ilike'));

      final filter2 = queryBuilder.filters[1].value as Map<String, dynamic>;
      expect(filter2['op'], equals('in'));
    });

    test('retorna this para encadenamiento', () {
      final result = queryBuilder.not('id', 'eq', 1);

      expect(result, same(queryBuilder));
    });
  });

  group('QueryBuilder - Múltiples filtros', () {
    test('permite combinar diferentes tipos de filtros', () {
      queryBuilder
        ..eq('active', true)
        ..gte('date', '2024-01-01')
        ..lte('date', '2024-12-31')
        ..ilike('name', '%search%')
        ..order('date', ascending: false)
        ..limit(20);

      expect(queryBuilder.filters, hasLength(4));
      expect(queryBuilder.filters[0].type, equals(FilterType.eq));
      expect(queryBuilder.filters[1].type, equals(FilterType.gte));
      expect(queryBuilder.filters[2].type, equals(FilterType.lte));
      expect(queryBuilder.filters[3].type, equals(FilterType.ilike));
      expect(queryBuilder.orders, hasLength(1));
      expect(queryBuilder.limitCount, equals(20));
    });

    test('mantiene el orden de los filtros agregados', () {
      queryBuilder
        ..eq('a', 1)
        ..neq('b', 2)
        ..gt('c', 3);

      expect(queryBuilder.filters[0].column, equals('a'));
      expect(queryBuilder.filters[1].column, equals('b'));
      expect(queryBuilder.filters[2].column, equals('c'));
    });
  });
}
