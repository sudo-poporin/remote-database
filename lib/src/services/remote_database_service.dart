import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio de configuración de la base de datos remota.
class RemoteDatabaseService {
  /// Inicializa el servicio de la base de datos remota.
  static Future<Supabase> init({
    required String supabaseUrl,
    required String supabaseAnnonKey,
  }) async {
    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnnonKey,
    );

    return supabase;
  }
}
