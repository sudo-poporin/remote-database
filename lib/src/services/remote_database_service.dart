// coverage:ignore-file
// Wrapper sobre `Supabase.initialize` (estático/I/O real) — no testeable
// en unit tests.

import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio de configuración de la base de datos remota.
class RemoteDatabaseService {
  /// Inicializa el servicio de la base de datos remota.
  static Future<Supabase> init({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      // TODO: migrar a `publishableKey` (anonKey deprecado en supabase 2.14,
      // requiere que los consumers provean el nuevo formato de key).
      // ignore: deprecated_member_use
      anonKey: supabaseAnonKey,
    );

    return supabase;
  }
}
