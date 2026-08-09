import 'dart:async';

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

  group('RemoteDatabaseBase.insertIfAbsent', () {
    late MockSupabaseClient mockClient;
    late MockSupabaseQuerySchema mockSchema;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late MockPostgrestListFilterBuilder mockFilterBuilder;
    late RemoteDatabaseBase database;


    setUp(() {
      mockClient = MockSupabaseClient();
      mockSchema = MockSupabaseQuerySchema();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      mockFilterBuilder = MockPostgrestListFilterBuilder();
      database = RemoteDatabaseBase(client: mockClient);

      when(mockClient.schema(any)).thenReturn(mockSchema);
      // `thenAnswer` en toda la cadena: los builders de PostgREST implementan
      // `Future`, y mockito rechaza devolverlos con `thenReturn`.
      when(mockSchema.from(any)).thenAnswer((_) => mockQueryBuilder);
      when(
        mockQueryBuilder.upsert(
          any,
          onConflict: anyNamed('onConflict'),
          ignoreDuplicates: anyNamed('ignoreDuplicates'),
        ),
      ).thenAnswer((_) => mockFilterBuilder);
    });

    /// Hace que `await ...select()` resuelva en [filas].
    ///
    /// Con un fake y no con un mock de mockito: `select()` no devuelve un
    /// `Future` sino un `PostgrestTransformBuilder`, que implementa `Future` a
    /// través de su propio `then`. Stubear ese `then` con mockito obliga a
    /// devolver un Future desde un `thenAnswer` anidado, y termina en
    /// `Cannot call when within a stub response`.
    void stubSelect(List<Map<String, dynamic>> filas) {
      when(
        mockFilterBuilder.select(),
      ).thenAnswer((_) => _FakeTransformBuilder(filas));
    }

    test('devuelve el id cuando la fila se insertó', () async {
      stubSelect([
        {'id': 42},
      ]);

      final result = await database.insertIfAbsent(
        table: 'membership',
        data: {'user_id': 'abc', 'item_id': 7},
        onConflict: 'user_id,item_id',
      );

      expect(result.getOrElse((_) => null), 42);
    });

    test('devuelve null cuando la fila ya estaba', () async {
      // `ignoreDuplicates: true` hace `ON CONFLICT DO NOTHING`, y entonces el
      // `select()` no trae ninguna fila. Ese vacío no es un error: es "no la
      // inserté yo".
      stubSelect([]);

      final result = await database.insertIfAbsent(
        table: 'membership',
        data: {'user_id': 'abc', 'item_id': 7},
        onConflict: 'user_id,item_id',
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => 99), isNull);
    });

    test('pasa onConflict e ignoreDuplicates al cliente', () async {
      stubSelect([]);

      await database.insertIfAbsent(
        table: 'membership',
        data: {'user_id': 'abc', 'item_id': 7},
        onConflict: 'user_id,item_id',
      );

      // Sin `ignoreDuplicates` el upsert pisaría la fila existente en vez de
      // dejarla intacta, que es lo contrario de lo que este método promete.
      verify(
        mockQueryBuilder.upsert(
          any,
          onConflict: 'user_id,item_id',
          ignoreDuplicates: true,
        ),
      ).called(1);
    });

    test('respeta resultIdColumn', () async {
      stubSelect([
        {'membership_id': 7},
      ]);

      final result = await database.insertIfAbsent(
        table: 'membership',
        data: {'user_id': 'abc'},
        onConflict: 'user_id,item_id',
        resultIdColumn: 'membership_id',
      );

      expect(result.getOrElse((_) => null), 7);
    });

    test('ante una excepción devuelve Left de insertFailure', () async {
      when(mockFilterBuilder.select()).thenThrow(Exception('boom'));

      final result = await database.insertIfAbsent(
        table: 'membership',
        data: {'user_id': 'abc'},
        onConflict: 'user_id,item_id',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (exception) => expect(exception, isA<RemoteDatabaseExceptions>()),
        (_) => fail('Se esperaba un Left'),
      );
    });
  });
}

/// Transform builder que resuelve en una lista fija.
///
/// `PostgrestTransformBuilder` implementa `Future` a través de `then`, así que
/// alcanza con implementar ese método para que el `await` del código bajo
/// prueba funcione.
class _FakeTransformBuilder extends Fake
    implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  _FakeTransformBuilder(this._filas);

  final List<Map<String, dynamic>> _filas;

  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) async => onValue(_filas);
}
