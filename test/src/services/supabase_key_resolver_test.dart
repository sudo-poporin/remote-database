import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/src/services/supabase_key_resolver.dart';

void main() {
  group('resolveSupabaseKey', () {
    test('devuelve publishableKey cuando se provee', () {
      final key = resolveSupabaseKey(publishableKey: 'pub-key');

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
