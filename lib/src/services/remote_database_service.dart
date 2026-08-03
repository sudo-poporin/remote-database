// coverage:ignore-file
// Wrapper sobre `Supabase.initialize` (estático/I/O real) — no testeable
// en unit tests.

import 'package:remote_database/src/services/supabase_key_resolver.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio de configuración de la base de datos remota.
class RemoteDatabaseService {
  /// Inicializa el servicio de la base de datos remota.
  ///
  /// Se debe proveer [supabasePublishableKey].
  static Future<Supabase> init({
    required String supabaseUrl,
    String? supabasePublishableKey,
  }) async {
    final key = resolveSupabaseKey(
      publishableKey: supabasePublishableKey,
    );

    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: key,
    );

    return supabase;
  }
}
