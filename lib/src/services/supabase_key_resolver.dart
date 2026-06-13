/// Resuelve la key efectiva a usar en `Supabase.initialize`.
///
/// Precedencia: [publishableKey] sobre [anonKey]. Lanza [ArgumentError]
/// si no se provee ninguna.
String resolveSupabaseKey({
  String? publishableKey,
  String? anonKey,
}) {
  final key = publishableKey ?? anonKey;
  if (key == null) {
    throw ArgumentError(
      'Se debe proveer una key: publishableKey/supabasePublishableKey '
      'o anonKey/supabaseAnonKey.',
    );
  }
  return key;
}
