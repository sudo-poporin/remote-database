import 'package:flutter_test/flutter_test.dart';
import 'package:remote_database/src/remote_database.dart';

import '../dependencies/mock_runner_test.mocks.dart';

void main() {
  final client = MockSupabaseClient();

  group('Repository: RemoteDatabaseBase', () {
    test('Se crea una instancia de RemoteDatabaseBase', () {
      expect(RemoteDatabaseBase(client: client), isNotNull);
    });
  });
}
