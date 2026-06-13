import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/src/services/supabase_key_resolver.dart';

void main() {
  group('resolveSupabaseKey', () {
    test('devuelve publishableKey cuando solo se provee publishableKey', () {
      final key = resolveSupabaseKey(publishableKey: 'pub-key');

      expect(key, 'pub-key');
    });

    test('devuelve anonKey cuando solo se provee anonKey', () {
      final key = resolveSupabaseKey(anonKey: 'anon-key');

      expect(key, 'anon-key');
    });

    test('prioriza publishableKey cuando se proveen ambas', () {
      final key = resolveSupabaseKey(
        publishableKey: 'pub-key',
        anonKey: 'anon-key',
      );

      expect(key, 'pub-key');
    });

    test('lanza ArgumentError cuando no se provee ninguna key', () {
      expect(
        resolveSupabaseKey,
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
