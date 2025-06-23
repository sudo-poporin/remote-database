import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/src/remote_database.dart';

import '../dependencies/mock_runner_test.mocks.dart';

void main() {
  final client = MockSupabaseClient();

  group('Repository: RemoteDatabase', () {
    test('Se crea una instancia de RemoteDatabase', () {
      expect(RemoteDatabase(client: client), isNotNull);
    });
  });
}
