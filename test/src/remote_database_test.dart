import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:remote_database/remote_database.dart';

import '../dependencies/mock_runner_test.mocks.dart';

void main() {
  final client = MockSupabaseClient();

  group('Repository: RemoteDatabaseBase', () {
    test('Se crea una instancia de RemoteDatabaseBase', () {
      expect(RemoteDatabaseBase(client: client), isNotNull);
    });
  });

  group('RemoteDatabaseBase.deleteWhereIn', () {
    late MockSupabaseClient mockClient;
    late RemoteDatabaseBase database;

    setUp(() {
      mockClient = MockSupabaseClient();
      database = RemoteDatabaseBase(client: mockClient);
    });

    test('con values vacío devuelve Left de deleteFailure', () async {
      final result = await database.deleteWhereIn(
        table: 'order_item',
        column: 'order_id',
        values: [],
        where: {'user_id': 'abc'},
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (exception) => expect(exception, isA<RemoteDatabaseExceptions>()),
        (_) => fail('Se esperaba un Left'),
      );
    });

    test('con values vacío no toca el cliente', () async {
      await database.deleteWhereIn(
        table: 'order_item',
        column: 'order_id',
        values: [],
        where: {'user_id': 'abc'},
      );

      verifyZeroInteractions(mockClient);
    });

    test('con where vacío devuelve Left de deleteFailure', () async {
      final result = await database.deleteWhereIn(
        table: 'order_item',
        column: 'order_id',
        values: [12, 34],
        where: {},
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (exception) => expect(exception, isA<RemoteDatabaseExceptions>()),
        (_) => fail('Se esperaba un Left'),
      );
    });

    test('con where vacío no toca el cliente', () async {
      await database.deleteWhereIn(
        table: 'order_item',
        column: 'order_id',
        values: [12, 34],
        where: {},
      );

      verifyZeroInteractions(mockClient);
    });
  });
}
